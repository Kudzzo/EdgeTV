# EdgeTV
**High-Performance Video Player with Synchronized Audio to Radiomaster Radios**

Created by **Kudzz**  
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/kudzz)

EdgeTV brings smooth video playback with synchronized audio to EdgeTX radios (such as the RadioMaster Pocket). It relies on a custom binary Run-Length Encoding (RLE) engine designed to bypass CPU watchdog limits without dropping frames.

---

> [!CAUTION]
> **DISCLAIMER:** Use at your own risk. The developer is not responsible for any damage or unexpected behavior on your radio.

---

## Features
- **Smooth 10 FPS Playback:** Clean, hardware-accelerated monochrome rendering.
- **Synchronized Audio:** Crisp audio playback aligned with the video stream.
- **Hardware Switch:**
  - **SA Switch (Top-Left):** Toggle Loop Mode on/off.
  - **SD Switch (Top-Right):** Toggle Auto-Next (Binge Mode) on/off.
- **Directory Hierarchy:** Isolates each video in its own folder to prevent OS path buffer overflows.
- **Batch Video Encoding:** Convert single videos or entire folders in a single command.
- **Windows support:**
- **Auto-Generated Playlists:** Automatically creates and updates `playlists.txt`.
---

## 📂 SD Card Layout

    /SCRIPTS/TOOLS/EdgeTV.lua
    /VIDEO/
    ├── playlists.txt
    ├── Video_Title_1/
    │   ├── Video_Title_1.rle
    │   └── audio.wav
    └── Video_Title_2/
        ├── Video_Title_2.rle
        └── audio.wav

> **Note:** Audio files are always named `audio.wav` inside each video's folder. This guarantees that file paths remain safely under the system's 40-character limit.

---

## Installation

1. Download the latest release package from the **[Releases Page](../../releases/latest)**.
2. Connect your radio's SD card to your computer (or select **USB Storage (SD)** on the radio).
3. Copy `EdgeTV.lua` into:
       /SCRIPTS/TOOLS/
4. Copy the `VIDEO` folder to the root of your SD card:
       /VIDEO/
5. Safely eject the SD card.

---

## Radio Controls

Launch EdgeTV on your radio by pressing **SYS** -> **TOOLS** -> **EdgeTV**.

| Control | Action |
| :--- | :--- |
| **Roller Click (Enter)** | Play selected video |
| **Exit Button (RTN)** | Stop video & audio immediately / Return to menu |
| **SA Switch (Top-Left)** | **DOWN:** Loop current video on repeat<br>**UP:** Normal playback |
| **SD Switch (Top-Right)** | **DOWN:** Auto-play next video in playlist<br>**UP:** Stop after video finishes |

---

## Converting Videos

The converter tool transforms standard video files (`.mp4`, `.mkv`, `.avi`, `.mov`) into EdgeTV's custom `.rle` and `.wav` formats.

### Windows (Standalone `.exe`):
1. Open the `PC` folder from the release package.
2. Double-click `EdgeTV_Encoder.exe` (keep `ffmpeg.exe` in the same directory).
3. Drag and drop your video file (or a whole folder of videos) into the window and press **Enter**.
4. Press **Enter** to accept the recommended default settings (10 FPS, 128 threshold) or enter custom values.
5. Copy the generated folders and `playlists.txt` into `/VIDEO/` on your SD card.

### Linux / Python CLI:
Requirements: Python 3, Pillow (`pip install Pillow`), and FFmpeg.

**Single video:**
    python encode_video.py "my_video.mp4"

**Batch convert an entire folder:**
    python encode_video.py -b "/path/to/videos/"

**Auto-organize an existing messy `/VIDEO/` folder:**
    python encode_video.py --organize "/path/to/SD/VIDEO"

### Converter Options:
| Flag | Description | Default |
| :--- | :--- | :--- |
| `-b, --batch <FOLDER>` | Batch convert all videos in a directory | None |
| `--fps <NUMBER>` | Frames per second | 10 |
| `--threshold <0-255>` | Brightness cutoff (Higher = Darker, Lower = Lighter) | 128 |
| `--invert` | Invert black and white pixels | Off |
| `-o <FOLDER>` | Custom output directory | `VIDEO_OUT` |
| `--organize <FOLDER>` | Sort loose files into safe subfolders automatically | None |

---

## ☕ Support the Project
If you enjoy EdgeTV and want to support its ongoing development:  
--> **[Buy Kudzz a coffee on Ko-fi](https://ko-fi.com/kudzz)**

## 📜 License
This project is open-source and released under the **[MIT License](LICENSE)**.
