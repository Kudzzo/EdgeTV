local VIDEO_FPS = 10
local TICKS_PER_FRAME = math.floor(100 / VIDEO_FPS)

-- App States
local STATE_MENU = 0
local STATE_PLAYING = 1
local STATE_FINISHED = 2
local state = STATE_MENU

-- State Variables
local f = nil
local startTime = 0
local currentFrame = 0
local currentData = ""
local totalFrames = 0

-- UI Variables
local playlist = {}
local selectedIndex = 1
local menuScroll = 0
local loopVideo = false

-- ==========================================
-- INIT: Read Playlist
-- ==========================================
local pf = io.open("/VIDEO/playlist.txt", "r")
if pf then
    local content = io.read(pf, 2048)
    io.close(pf)
    if content then
        for line in string.gmatch(content, "[^\r\n]+") do
            playlist[#playlist + 1] = line
            end
            end
            end
            if #playlist == 0 then playlist[1] = "No playlist.txt!" end

                -- ==========================================
                -- HELPER: Start a Video
                -- ==========================================
                local function startVideo(name)
                if f then io.close(f) end

                    local rlePath = "/VIDEO/" .. name .. ".rle"
                    local wavPath = "/VIDEO/" .. name .. ".wav"

                    f = io.open(rlePath, "rb")
                    if not f then return false end

                        totalFrames = 0
                        local magic = io.read(f, 4)
                        if magic == "RLE2" then
                            local tf_b = io.read(f, 4)
                            local b1, b2, b3, b4 = string.byte(tf_b, 1, 4)
                            totalFrames = b1 + (b2 * 256) + (b3 * 65536) + (b4 * 16777216)
                            else
                                io.close(f)
                                f = io.open(rlePath, "rb")
                                end

                                playFile(wavPath)
                                state = STATE_PLAYING
                                startTime = getTime()
                                currentFrame = 0
                                currentData = ""
                                collectgarbage()
                                return true
                                end

                                -- ==========================================
                                -- MAIN LOOP
                                -- ==========================================
                                local function run(event)
                                lcd.clear()

                                -- ==========================================
                                -- EXIT / STOP LOGIC
                                -- ==========================================
                                if event == EVT_EXIT_BREAK then
                                    -- 1. KILL AUDIO IMMEDIATELY
                                    -- We play a fake file. This forces EdgeTX to drop the current song.
                                    playFile("")

                                    -- 2. Handle State
                                    if state == STATE_PLAYING or state == STATE_FINISHED then
                                        -- If we were watching a video, close it and go back to menu
                                        if f then io.close(f); f = nil end
                                            state = STATE_MENU
                                            collectgarbage()
                                            return 0 -- Stay in the app
                                            else
                                                -- If we were already in the menu, quit the app
                                                return 1
                                                end
                                                end

                                                -- ==========================================
                                                -- MENU UI
                                                -- ==========================================
                                                if state == STATE_MENU then
                                                    if event == EVT_ROT_RIGHT or event == EVT_MINUS_BREAK or event == EVT_DOWN_BREAK then
                                                        selectedIndex = selectedIndex + 1
                                                        if selectedIndex > #playlist then selectedIndex = 1 end
                                                            elseif event == EVT_ROT_LEFT or event == EVT_PLUS_BREAK or event == EVT_UP_BREAK then
                                                                selectedIndex = selectedIndex - 1
                                                                if selectedIndex < 1 then selectedIndex = #playlist end
                                                                    elseif event == EVT_PAGE_BREAK then
                                                                        loopVideo = not loopVideo
                                                                        elseif event == EVT_ENTER_BREAK then
                                                                            if not startVideo(playlist[selectedIndex]) then
                                                                                -- Fail silently
                                                                                end
                                                                                end

                                                                                lcd.drawText(0, 0, "      EdgeTV Player      ", INVERS)

                                                                                if selectedIndex > menuScroll + 4 then menuScroll = selectedIndex - 4 end
                                                                                    if selectedIndex <= menuScroll then menuScroll = selectedIndex - 1 end

                                                                                        for i = 1, 4 do
                                                                                            local idx = menuScroll + i
                                                                                            if idx <= #playlist then
                                                                                                local text = playlist[idx]
                                                                                                if idx == selectedIndex then
                                                                                                    lcd.drawText(2, 12 + (i-1)*10, "> " .. text, 0)
                                                                                                    else
                                                                                                        lcd.drawText(10, 12 + (i-1)*10, text, 0)
                                                                                                        end
                                                                                                        end
                                                                                                        end

                                                                                                        lcd.drawLine(0, 53, 128, 53, SOLID, 0)
                                                                                                        lcd.drawText(1, 56, "[ENT]Play [PGE]Lp:"..(loopVideo and "ON" or "OFF"), 0)

                                                                                                        -- ==========================================
                                                                                                        -- PLAYING UI
                                                                                                        -- ==========================================
                                                                                                        elseif state == STATE_PLAYING then

                                                                                                            local now = getTime()
                                                                                                            local targetFrame = math.floor((now - startTime) / TICKS_PER_FRAME)

                                                                                                            if targetFrame > currentFrame then
                                                                                                                while currentFrame < targetFrame do
                                                                                                                    local len_b = io.read(f, 2)
                                                                                                                    if not len_b or #len_b < 2 then
                                                                                                                        state = STATE_FINISHED
                                                                                                                        if f then io.close(f); f = nil end
                                                                                                                            break
                                                                                                                            end

                                                                                                                            local b1, b2 = string.byte(len_b, 1, 2)
                                                                                                                            local len = b1 + (b2 * 256)

                                                                                                                            if len > 2048 then
                                                                                                                                state = STATE_MENU; if f then io.close(f); f = nil end; break
                                                                                                                                end

                                                                                                                                if len > 0 then
                                                                                                                                    local data = io.read(f, len)
                                                                                                                                    if currentFrame == targetFrame - 1 then currentData = data end
                                                                                                                                        else
                                                                                                                                            if currentFrame == targetFrame - 1 then currentData = "" end
                                                                                                                                                end
                                                                                                                                                currentFrame = currentFrame + 1
                                                                                                                                                end
                                                                                                                                                end

                                                                                                                                                if currentData and #currentData > 0 then
                                                                                                                                                    for i = 1, #currentData, 3 do
                                                                                                                                                        local y, x1, x2 = string.byte(currentData, i, i+2)
                                                                                                                                                        lcd.drawLine(x1, y, x2, y, SOLID, 0)
                                                                                                                                                        end
                                                                                                                                                        end

                                                                                                                                                        if totalFrames > 0 then
                                                                                                                                                            local progW = math.floor((currentFrame / totalFrames) * 128)
                                                                                                                                                            if progW > 128 then progW = 128 end
                                                                                                                                                                if progW < 0 then progW = 0 end

                                                                                                                                                                    lcd.drawLine(0, 63, progW, 63, SOLID, 0)
                                                                                                                                                                    lcd.drawLine(0, 62, progW, 62, SOLID, 0)
                                                                                                                                                                    lcd.drawLine(0, 61, progW, 61, SOLID, 0)
                                                                                                                                                                    end

                                                                                                                                                                    -- ==========================================
                                                                                                                                                                    -- FINISHED / LOOPING STATE
                                                                                                                                                                    -- ==========================================
                                                                                                                                                                    elseif state == STATE_FINISHED then
                                                                                                                                                                        if loopVideo then
                                                                                                                                                                            startVideo(playlist[selectedIndex])
                                                                                                                                                                            else
                                                                                                                                                                                state = STATE_MENU
                                                                                                                                                                                end
                                                                                                                                                                                end

                                                                                                                                                                                return 0
                                                                                                                                                                                end

                                                                                                                                                                                return { run = run }
