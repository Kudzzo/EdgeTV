EdgeTV v3.1 (Windows Edition)
Created by Kudzz

WARNING: IF THIS BREAKS YOUR CONTROLLER, I AM NOT RESPONSIBLE FOR DAMAGES.
DO IT AT YOUR OWN RISK!

-------------------------------------------------------
WHAT IS THIS?
-------------------------------------------------------
EdgeTV is a video player for the RadioMaster Pocket (and monochrome
EdgeTX radios). It plays video and audio smoothly at 10 frames per
second with synchronized sound.

-------------------------------------------------------
HOW TO INSTALL
-------------------------------------------------------
1. Plug your radio into your PC and choose "USB Storage (SD)",
   or insert your SD card into your computer.

2. Open your SD card drive in File Explorer (for example: E:\ or F:\).

3. Copy "EdgeTV.lua" into:
   X:\SCRIPTS\TOOLS\
   (Replace "X" with your actual SD card drive letter)

4. Copy the "VIDEO" folder to the main root of your SD card:
   X:\VIDEO\

Your SD card folder structure must look like this:
X:\SCRIPTS\TOOLS\EdgeTV.lua
X:\VIDEO\playlists.txt
X:\VIDEO\Bad-Apple\Bad-Apple.rle
X:\VIDEO\Bad-Apple\audio.wav

NOTE: The audio file is named "audio.wav" inside each video's folder.
This is required to prevent the "Path too long" error!

5. Safely eject the SD card and unplug the USB cable.

-------------------------------------------------------
HOW TO USE ON RADIO
-------------------------------------------------------
1. Turn on your radio.
2. Press the "SYS" button.
3. Go to the "TOOLS" menu.
4. Scroll down and open "EdgeTV".

CONTROLS:
- Roller Click (Enter): Play selected video
- Exit Button (RTN)   : Instantly stop video and audio / Go back
- SA Switch (Top-Left):
    DOWN = Loop current video on repeat
    UP   = Normal mode
- SD Switch (Top-Right):
    DOWN = Auto-Next plays next video in list automatically
    UP   = Normal mode

-------------------------------------------------------
HOW TO CONVERT YOUR OWN VIDEOS
-------------------------------------------------------
1. Open the "PC" folder.

2. Double-click "EdgeTV_Encoder.exe".
   (Make sure "ffmpeg.exe" is in the same folder!)

3. Drag and drop your video file (or a whole folder of videos)
   into Command Prompt(Terminal) and press Enter.

4. You will be asked for settings:
   - Frames per second [Default: 10] -> Just press Enter
   - B&W Threshold [Default: 128]     -> Higher = Darker, Lower = Lighter
   - Invert Colors? [Default: N]      -> Type Y if colors look inverted
   - Output folder [Default: VIDEO_OUT] -> Press Enter

5. Once finished, open the "VIDEO_OUT" folder.

6. Copy the video folders and the auto-generated "playlists.txt"
   directly into X:\VIDEO\ on your SD card.

BATCH CONVERTING AN ENTIRE FOLDER:
Drag and drop an entire folder filled with MP4 videos into the
encoder window. It will encode all of them automatically and build
your "playlists.txt" for you!

AUTO-ORGANIZE EXISTING FILES:
If you have old loose .rle and .wav files on your SD card, open
Command Prompt in your PC folder and run:
   EdgeTV_Encoder.exe --organize "X:\VIDEO"
It will instantly sort them into clean folders in 2 seconds!

-------------------------------------------------------
SUPPORT ME
-------------------------------------------------------
If you like this project and want to support the development time,
you can buy me a coffee here:
https://ko-fi.com/kudzz

Enjoy!
- Kudzz
