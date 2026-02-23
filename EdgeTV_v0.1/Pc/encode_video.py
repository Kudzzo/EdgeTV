import os
import sys
import subprocess
import tempfile
import argparse
import shutil

try:
    from PIL import Image
except ImportError:
    print("Error: Please run: pip install Pillow")
    sys.exit(1)

def check_dependencies():
    if shutil.which("ffmpeg") is None:
        print("Error: FFmpeg is not installed.")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description="EdgeTV V2 RLE Video Encoder")
    parser.add_argument("input", help="Path to input video")
    parser.add_argument("-o", "--outdir", default="VIDEO_OUT", help="Output directory")
    parser.add_argument("--fps", type=int, default=10, help="Frames per second")
    parser.add_argument("--threshold", type=int, default=128, help="B&W threshold 0-255")
    parser.add_argument("--invert", action="store_true", help="Invert colors")
    args = parser.parse_args()

    check_dependencies()

    # Automatically name the output files based on the input video!
    base_name = os.path.splitext(os.path.basename(args.input))[0]
    os.makedirs(args.outdir, exist_ok=True)
    rle_out = os.path.join(args.outdir, f"{base_name}.rle")
    audio_out = os.path.join(args.outdir, f"{base_name}.wav")

    with tempfile.TemporaryDirectory() as temp_dir:
        print(f"Extracting frames for '{base_name}'...")
        subprocess.run(["ffmpeg", "-i", args.input, "-vf", f"scale=128:64,fps={args.fps}", os.path.join(temp_dir, "f_%04d.png"), "-y"], capture_output=True)
        subprocess.run(["ffmpeg", "-i", args.input, "-ac", "1", "-ar", "8000", "-sample_fmt", "s16", "-af", "volume=0.6", audio_out, "-y"], capture_output=True)

        print("Generating V2 RLE binary payload...")
        with open(rle_out, "wb") as out_file:
            # V2 Header: "RLE2" + 4-byte placeholder for total frames
            out_file.write(b"RLE2")
            out_file.write((0).to_bytes(4, byteorder='little'))

            frame_idx = 1
            while True:
                fname = os.path.join(temp_dir, f"f_{frame_idx:04d}.png")
                if not os.path.exists(fname): break

                img = Image.open(fname).convert("L")
                pixels = img.load()
                frame_data = bytearray()

                for y in range(64):
                    in_line = False
                    x_start = 0
                    for x in range(128):
                        is_black = (pixels[x, y] < args.threshold)
                        if args.invert: is_black = not is_black

                        if is_black and not in_line:
                            x_start, in_line = x, True
                        elif not is_black and in_line:
                            frame_data.extend([y, x_start, x - 1])
                            in_line = False
                    if in_line: frame_data.extend([y, x_start, 127])

                out_file.write(len(frame_data).to_bytes(2, byteorder='little'))
                out_file.write(frame_data)
                frame_idx += 1

            # Go back to the header and write the actual total frame count!
            total_frames = frame_idx - 1
            out_file.seek(4)
            out_file.write(total_frames.to_bytes(4, byteorder='little'))

        print(f"Done! Created '{base_name}.rle' and '{base_name}.wav' in {args.outdir}/")
        print("Put them in your SD Card /VIDEO/ folder and add the name to playlist.txt")

if __name__ == "__main__":
    main()
