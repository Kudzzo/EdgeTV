
# EdgeTV v0.1 📺
**A smooth 10FPS Video Player for the RadioMaster Pocket (EdgeTX)**
**This Was Made With Linux So Be Sure To Check Your Paths**

Created by **Kudzz**  
[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/kudzz)

EdgeTV is an open-source video player designed specifically for monochrome EdgeTX radios like the RadioMaster Pocket. It uses a custom Run-Length Encoding (RLE) system to bypass hardware limitations and provide smooth playback with synchronized audio.

---

> [!CAUTION]
> **WARNING:** If this breaks your controller, I am not responsible for the damages. Use at your own risk!

---

## 📂 Project Structure
- **/Sd_Card**: Contains the Lua script and a demo of "Bad Apple".
- **/Pc**: Contains the Python script to encode your own videos.

## 🚀 Installation

1. **Prepare the SD Card:** Connect your Radio's SD Card to your computer.
2. **Install the Script:** Copy `EdgeTV.lua` from the `/Sd_Card` folder to:
   - the SD card: `/SCRIPTS/TOOLS/`
3. **Setup Video Folder:** Create a folder on the root of your SD Card named `/VIDEO/`.
4. **Add Content:** Copy these files into the new `/VIDEO/` folder:
   - `Bad-Apple.rle`
   - `Bad-Apple.wav`
   - `playlists.txt`

## 🎮 How to Use
1. Turn on your Radio and press the **SYS** button.
2. Navigate to the **TOOLS** menu.
3. Select **EdgeTV**.

### Controls
| Control | Action |
| :--- | :--- |
| **Roller Click (Enter)** | Play selected video |
| **Exit Button** | Stop video / Return to menu |
| **Page Button** | Toggle Loop Mode (ON/OFF) |

*Note: In EdgeTX 2.10.5, audio may continue for a few seconds after exiting a long video. This is a known limitation.*

## 🎞️ Importing Your Own Videos
To convert your own videos, you will need **Python** and the **Pillow** library installed on your computer.

1. Open the `/Pc` folder.
2. Run the encoder script (replace "myvideo.mp4" to your video name:
   ```bash
   python encode_video.py myvideo.mp4
3. Copy the generated .rle and .wav files to the /VIDEO/ folder on your SD card.

4. Create or Open playlists.txt on your SD card in /VIDEO/ folder and add the video name (without the extension. MUST BE EXACT FILE NAME).

Advanced Encoding Flags
Flag	Description	Default

--invert	Inverts black and white pixels	Off

--fps	Set custom frames per second	10

--threshold	Set B&W brightness cutoff (0-255)	128

-o	Set custom output directory	/VIDEO_OUT

-h	Show help menu	N/A


🛠️ Development Note
This project was developed on Linux (Arch Linux). While it is fully compatible with Windows and MacOS, the instructions and scripts are biased toward a Linux environment.

☕ Support Me
If you enjoy this project and want to support the time spent developing it, feel free to buy me a coffee!

📜 License
This project is licensed under the MIT License - see the LICENSE file for details.
