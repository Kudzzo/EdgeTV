EdgeTV
The Complete Video Player for EdgeTX
Color (TX16S) & Monochrome (Pocket)
-------------------------------------------------------
TABLE OF CONTENTS
-------------------------------------------------------
1. Overview & Radio Types
2. PART 1: Color Radios (RadioMaster TX16S, etc.)
   - Features & Specs
   - SD Card Setup (.vid)
   - Radio Controls
   - How to Encode Color Videos
3. PART 2: Monochrome Radios (RadioMaster Pocket, etc.)
   - Features & Specs
   - SD Card Setup (.rle)
   - Radio Controls
   - How to Encode Monochrome Videos
4. Important Rules & Troubleshooting
5. Support the Project

OVERVIEW & RADIO TYPES
=======================================================

EdgeTV supports two different display types using two 
different custom engines:

- COLOR RADIOS (RadioMaster TX16S, etc.):
  Uses the .vid container (full-color video stream at 
  15 FPS, widescreen 480x272).

- MONOCHROME RADIOS (RadioMaster Pocket, TX12, Zorro, etc.):
  Uses the .rle container (custom binary line-drawing 
  engine at 10 FPS, 128x64 black and white).

Both versions pack the entire movie into a single file 
accompanied only by "audio.wav", keeping your SD card 
clean without thousands of loose images.


PART 1: COLOR RADIOS (RadioMaster TX16S)
=======================================================

SPECS:
- Display: Full Color Widescreen (480x272)
- Framerate: 7-8 FPS (Hard limit)
- Format: .vid container (EVID)
- Audio: 16kHz Mono WAV

SD CARD FILE STRUCTURE:
Copy "EdgeTV.lua" (or EdgeTV_Color.lua) to:
  /SCRIPTS/TOOLS/EdgeTV.lua

Your /VIDEO/ folder on the SD card must look like this:
  /VIDEO/playlists.txt
  /VIDEO/<Video_Name>/<Video_Name>.vid
  /VIDEO/<Video_Name>/audio.wav

* Note: The audio file inside the video folder MUST be 
  named "audio.wav". This keeps the path short and prevents 
  EdgeTX "Path too long" errors!

RADIO CONTROLS (TX16S):
- Open App: Press SYS button -> TOOLS tab -> Select "EdgeTV"
- Roller Click (Enter): Play selected video
- SA Switch:
    DOWN = Loop current video on repeat
    UP   = Normal playback
- SD Switch:
    DOWN = Auto-Next (Binge Mode) plays next video in list
    UP   = Stop after video finishes

* 1.5-SECOND TRANSITION SCREEN:
  When Auto-Next or Loop is active, a dark "Up Next..." 
  screen with a 1.5-second countdown bar appears between 
  videos. This allows the radio audio engine to completely 
  reset so the next video starts in 100% sync!

HOW TO ENCODE COLOR VIDEOS:
Windows (Executable):
1. Open the "PC" folder.
2. Double-click "EdgeTV_Encoder.exe" (keep ffmpeg.exe next to it).
3. Drag and drop your video file (or a whole folder of videos) 
   into the window and press Enter.
4. When asked for quality, type "high" and press Enter.
5. Copy the output folder to /VIDEO/ on your SD card.
6. Add the name to /VIDEO/playlists.txt.

Linux (Python):
  Single video:
    python encode_video.py my_video.mp4 -q high
  Batch folder:
    python encode_video.py -b /path/to/videos/ -q high


PART 2: MONOCHROME RADIOS (RadioMaster Pocket, etc.)
======================================================= 

SPECS:
- Display: 128x64 Monochrome LCD
- Framerate: 10 FPS (Safe for STM32 processor limits)
- Format: .rle container (RLE2 binary bytecode)
- Audio: 8kHz Mono WAV

SD CARD FILE STRUCTURE:
Copy "EdgeTV.lua" to:
  /SCRIPTS/TOOLS/EdgeTV.lua

Your /VIDEO/ folder on the SD card must look like this:
  /VIDEO/playlists.txt
  /VIDEO/<Video_Name>/<Video_Name>.rle
  /VIDEO/<Video_Name>/audio.wav

* Note: The audio file inside the video folder MUST be 
  named "audio.wav" to stay under the 40-character limit!

RADIO CONTROLS (Pocket / Monochrome):
- Open App: Press SYS button -> TOOLS menu -> Select "EdgeTV"
- Roller Click (Enter): Play selected video
- RTN / Exit Button: Stop video and audio immediately / Go back
- SA Switch (Top-Left):
    DOWN = Loop current video on repeat
    UP   = Normal playback
- SD Switch (Top-Right):
    DOWN = Auto-Next (Binge Mode) plays next video in list
    UP   = Stop after video finishes

HOW TO ENCODE MONOCHROME VIDEOS:
Windows (Executable):
1. Open the "PC" folder.
2. Double-click your monochrome encoder executable.
3. Drag and drop your video file into the window and press Enter.
4. Settings:
   - FPS: 10 (Recommended)
   - Threshold: 128 (Higher = Darker / Lower = Lighter)
   - Invert: N (Type Y if colors look inverted like a negative)
5. Copy the output folder to /VIDEO/ on your SD card.
6. Add the name to /VIDEO/playlists.txt.

Linux (Python):
  Single video:
    python encode_video.py my_video.mp4 --fps 10 --threshold 128
  Batch folder:
    python encode_video.py -b /path/to/videos/ --fps 10


IMPORTANT RULES & TROUBLESHOOTING
=======================================================

1. THE 40-CHARACTER AUDIO RULE:
   EdgeTX has a strict system limit: any audio path longer 
   than 40 characters will crash the sound engine and show 
   a "Path too long" error. 
   Always keep the sound file named "audio.wav" directly 
   inside the video folder:
     GOOD: /VIDEO/MyMovie/audio.wav (24 characters - Safe!)
     BAD:  /VIDEO/MyMovie/AUDIO/MyMovie.wav (37+ characters - Risky!)

2. PLAYLISTS.TXT RULES:
   - Place "playlists.txt" directly inside the /VIDEO/ folder.
   - Write each video folder name on its own line.
   - Do NOT add extensions like .vid, .rle, or .mp4 in the text file!
   Example playlists.txt:
     Bad-Apple
     RickRoll

3. AUTO-ORGANIZER TOOL:
   If you have old loose files from earlier versions, you can 
   sort them automatically without re-encoding:
     Windows: EdgeTV_Encoder.exe --organize "X:\VIDEO"
     Linux:   python encode_video.py --organize "/path/to/SD/VIDEO"


SUPPORT THE PROJECT
=======================================================

EdgeTV is free and open-source. If you enjoy watching 
videos on your radio controller and want to support 
the development time:

https://ko-fi.com/kudzz

Enjoy your radio cinema!
- Kudzz
=======================================================
