EdgeTV v0.1
Created by Kudzz

Note: These instructions were written on a Linux system (the OS used to develop this).
If you are on Windows, the steps are the same, just be aware of the drive letters (e.g., E:\ or F:\).

WARNING: IF THIS BREAKS YOUR CONTROLLER, I'M NOT RESPONSIBLE FOR THE DAMAGES.
DO IT AT YOUR OWN RISK!!!!

-------------------------------------------------------
WHAT IS THIS?
-------------------------------------------------------
This is a video player for the RadioMaster Pocket.
It plays video and audio smoothly at 10 frames per second.
It is open source and free to use.
It includes a demo of "Bad Apple".

-------------------------------------------------------
HOW TO INSTALL
-------------------------------------------------------
1. Connect your Radio's SD Card to your computer or plug in the controller and select the "USB Storage (SD)" option.

2. Open the "Sd_Card" folder in this zip file.

3. Copy "EdgeTV.lua" to this folder on your SD Card:
   /SCRIPTS/TOOLS/
   (or X:\SCRIPTS\TOOLS if you're on Windows)

4. Create a new folder on the main root of your SD Card called:
   /VIDEO/
   (or X:\VIDEO if you're on Windows)

   *Replace "X" with whatever drive letter your Windows machine assigns.

5. Copy these 3 files into that new /VIDEO/ folder:
   - Bad-Apple.rle
   - Bad-Apple.wav
   - playlists.txt

-------------------------------------------------------
HOW TO USE ON RADIO
-------------------------------------------------------
1. Turn on your Radio.
2. Press the "SYS" button.
3. Go to the "TOOLS" menu.
4. Scroll down and select "EdgeTV".

CONTROLS:
- Roller Click (Enter): Play Video
- Exit Button: Stop Video / Go Back
- Page Button: Turn Loop ON or OFF

Note: Beware of using long videos. The audio may continue to play if you exit
the video player before the video ends. As of now, there is no official
stopFile function in EdgeTX 2.10.5.

-------------------------------------------------------
HOW TO IMPORT YOUR OWN VIDEOS
-------------------------------------------------------
1. You need Python installed on your computer.
2. Open the "Pc" folder from this zip file.
3. Open a terminal or command prompt in that folder.
4. Type this command (replace myvideo.mp4 with your video file name MUST BE EXACT NAME, ELSE IT WILL MAKE A BLANK .rle FILE):

   python encode_video.py myvideo.mp4

5. This will create a .rle file and a .wav file.
6. Copy those two files to the /VIDEO/ folder on your SD Card.
7. Open "playlists.txt" on your SD Card and add the name of the video.
   (MUST BE THE EXACT FILE NAME WITHOUT THE .MP4 EXTENSION)

-------------------------------------------------------
ADVANCED OPTIONS (FLAGS)
-------------------------------------------------------
You can add these flags to the command to change settings:

--invert
   Inverts the colors (Black becomes White). Useful if the video looks
   like a negative.

--fps [NUMBER]
   Changes the Frames Per Second (default: 10).
   (Example: --fps 15)

--threshold [NUMBER]
   The threshold of the black and white pixels (0-255).
   Lower number = Whiter video.
   Higher number = Darker video.
   (Default: 128)

-o [FOLDER]
   Save files to a specific output folder.

-h
   Show the help menu.

-------------------------------------------------------
SUPPORT ME
-------------------------------------------------------
If you like this project, you can buy me a coffee here:
https://ko-fi.com/kudzz

Enjoy!
- Kudzz
