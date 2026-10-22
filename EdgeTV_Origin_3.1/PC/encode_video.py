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

SUPPORTED_EXTENSIONS = ('.mp4', '.mkv', '.avi', '.mov', '.webm')
# EdgeTX playFile() has a hard 40-character path limit
# "/VIDEO/" (7) + name + "/audio.wav" (10) = 17 + len(name) <= 40  -> max name is 23 chars
MAX_NAME_LEN = 22

def check_dependencies():
    if shutil.which("ffmpeg") is None:
        print("Error: FFmpeg is not installed or not found in system PATH.")
        sys.exit(1)

def organize_existing_folder(target_dir):
    """Organizes existing files into short, safe subfolders."""
    if not os.path.exists(target_dir):
        print(f"Error: Directory '{target_dir}' does not exist.")
        return

    print(f"Organizing files in: {target_dir}...")
    items = os.listdir(target_dir)

    count = 0
    # 1. Flatten existing nested AUDIO/ folders to audio.wav
    for item in items:
        sub_path = os.path.join(target_dir, item)
        if os.path.isdir(sub_path):
            audio_sub = os.path.join(sub_path, "AUDIO")
            if os.path.isdir(audio_sub):
                for f in os.listdir(audio_sub):
                    if f.lower().endswith(".wav"):
                        src = os.path.join(audio_sub, f)
                        dst = os.path.join(sub_path, "audio.wav")
                        shutil.move(src, dst)
                        print(f"  -> Flattened: {item}/AUDIO/{f} -> {item}/audio.wav")
                try:
                    os.rmdir(audio_sub)
                except Exception:
                    pass

    # 2. Sort any loose .rle and .wav files
    items = os.listdir(target_dir)
    rle_files = [f for f in items if f.lower().endswith('.rle')]
    for rle in rle_files:
        base_name = os.path.splitext(rle)[0]
        vid_folder = os.path.join(target_dir, base_name)
        os.makedirs(vid_folder, exist_ok=True)

        # Move RLE
        shutil.move(os.path.join(target_dir, rle), os.path.join(vid_folder, rle))

        # Move WAV
        loose_wav = os.path.join(target_dir, f"{base_name}.wav")
        if os.path.exists(loose_wav):
            shutil.move(loose_wav, os.path.join(vid_folder, "audio.wav"))
        count += 1
        print(f"  -> Grouped: {base_name}/ ({rle} + audio.wav)")

    print(f"\nFinished! All video folders now use short, safe paths.")

def encode_single_video(input_path, outdir, fps=10, threshold=128, invert=False):
    base_name = os.path.splitext(os.path.basename(input_path))[0]

    if len(base_name) > MAX_NAME_LEN:
        print(f"  [WARNING] Video name '{base_name}' is {len(base_name)} characters!")
        print(f"            EdgeTX playFile() has a 40-character limit. Consider shortening it.")

    video_dir = os.path.join(outdir, base_name)
    os.makedirs(video_dir, exist_ok=True)

    rle_out = os.path.join(video_dir, f"{base_name}.rle")
    audio_out = os.path.join(video_dir, "audio.wav")  # Short, safe name!

    with tempfile.TemporaryDirectory() as temp_dir:
        print(f"  [1/3] Extracting frames & audio with FFmpeg...")
        subprocess.run(
            ["ffmpeg", "-i", input_path, "-vf", f"scale=128:64,fps={fps}", os.path.join(temp_dir, "f_%04d.png"), "-y"],
            capture_output=True
        )
        subprocess.run(
            ["ffmpeg", "-i", input_path, "-ac", "1", "-ar", "8000", "-sample_fmt", "s16", "-af", "volume=0.6", audio_out, "-y"],
            capture_output=True
        )

        print(f"  [2/3] Compressing RLE binary payload...")
        with open(rle_out, "wb") as out_file:
            out_file.write(b"RLE2")
            out_file.write((0).to_bytes(4, byteorder='little'))

            frame_idx = 1
            while True:
                fname = os.path.join(temp_dir, f"f_{frame_idx:04d}.png")
                if not os.path.exists(fname):
                    break

                img = Image.open(fname).convert("L")
                pixels = img.load()
                frame_data = bytearray()

                for y in range(64):
                    in_line = False
                    x_start = 0
                    for x in range(128):
                        is_black = (pixels[x, y] < threshold)
                        if invert:
                            is_black = not is_black

                        if is_black and not in_line:
                            x_start, in_line = x, True
                        elif not is_black and in_line:
                            frame_data.extend([y, x_start, x - 1])
                            in_line = False
                    if in_line:
                        frame_data.extend([y, x_start, 127])

                out_file.write(len(frame_data).to_bytes(2, byteorder='little'))
                out_file.write(frame_data)
                frame_idx += 1

            total_frames = frame_idx - 1
            out_file.seek(4)
            out_file.write(total_frames.to_bytes(4, byteorder='little'))

        print(f"  [3/3] Done -> Created '{base_name}/{base_name}.rle' and 'audio.wav'")
        return base_name

def main():
    parser = argparse.ArgumentParser(description="EdgeTV Safe Path Video Encoder")
    parser.add_argument("input", nargs="?", default=None, help="Video file or folder path")
    parser.add_argument("-b", "--batch", metavar="FOLDER", default=None, help="Batch encode all videos in a folder")
    parser.add_argument("-o", "--outdir", default="VIDEO_OUT", help="Output directory (default: VIDEO_OUT)")
    parser.add_argument("--fps", type=int, default=10, help="Frames per second (default: 10)")
    parser.add_argument("--threshold", type=int, default=128, help="B&W threshold 0-255 (default: 128)")
    parser.add_argument("--invert", action="store_true", help="Invert colors")
    parser.add_argument("--organize", metavar="FOLDER", help="Auto-organize files to short safe paths")
    args = parser.parse_args()

    if args.organize:
        organize_existing_folder(args.organize)
        sys.exit(0)

    check_dependencies()

    target_folder = None
    single_file = None

    if args.batch:
        target_folder = args.batch
    elif args.input and os.path.isdir(args.input):
        target_folder = args.input
    elif args.input and os.path.isfile(args.input):
        single_file = args.input
    else:
        parser.print_help()
        sys.exit(1)

    if target_folder:
        all_files = sorted(os.listdir(target_folder))
        video_files = [
            os.path.join(target_folder, f)
            for f in all_files
            if f.lower().endswith(SUPPORTED_EXTENSIONS)
        ]

        if not video_files:
            print(f"No compatible videos found in '{target_folder}'.")
            sys.exit(1)

        print(f"EdgeTV Batch Encoder: Found {len(video_files)} video(s)")
        encoded_names = []
        for i, vid_path in enumerate(video_files, 1):
            filename = os.path.basename(vid_path)
            print(f"\n[{i}/{len(video_files)}] Processing '{filename}'...")
            try:
                name = encode_single_video(
                    vid_path,
                    outdir=args.outdir,
                    fps=args.fps,
                    threshold=args.threshold,
                    invert=args.invert
                )
                encoded_names.append(name)
            except Exception as e:
                print(f"  [ERROR] Failed to encode '{filename}': {e}")

        playlist_file = os.path.join(args.outdir, "playlists.txt")
        with open(playlist_file, "w", encoding="utf-8") as f:
            for name in encoded_names:
                f.write(f"{name}\n")

        print("\nSUCCESS! All videos encoded with safe short audio paths.")
    elif single_file:
        encode_single_video(
            single_file,
            outdir=args.outdir,
            fps=args.fps,
            threshold=args.threshold,
            invert=args.invert
        )

if __name__ == "__main__":
    main()
