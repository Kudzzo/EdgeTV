local VIDEO_FPS = 10
local TICKS_PER_FRAME = math.floor(100 / VIDEO_FPS)
local MAX_LINES_PER_FRAME = 450

-- App States
local STATE_SPLASH = -1
local STATE_MENU = 0
local STATE_PLAYING = 1
local STATE_FINISHED = 2
local state = STATE_SPLASH

-- State Variables
local f = nil
local startTime = 0
local splashTime = 0
local currentFrame = 0
local currentData = ""
local totalFrames = 0

-- UI Variables
local playlist = {}
local selectedIndex = 1
local menuScroll = 0
local loopVideo = false
local autoNext = false

-- ==========================================
-- INIT: Read Playlist
-- ==========================================
local pf = io.open("/VIDEO/playlists.txt", "r")
if pf then
    local content = io.read(pf, 4096)
    io.close(pf)
    if content then
        for line in string.gmatch(content, "[^\r\n]+") do
            local name = string.gsub(line, "%s+", "")
            if #name > 0 then
                playlist[#playlist + 1] = name
                end
                end
                end
                end
                if #playlist == 0 then playlist[1] = "No playlists.txt!" end

                    -- ==========================================
                    -- HELPER: Start a Video (Safe Path Lengths)
                    -- ==========================================
                    local function startVideo(name)
                    if f then io.close(f) end

                        -- 1. Locate Video File
                        local rlePath = "/VIDEO/" .. name .. "/" .. name .. ".rle"
                        f = io.open(rlePath, "rb")
                        if not f then
                            rlePath = "/VIDEO/" .. name .. "/video.rle"
                            f = io.open(rlePath, "rb")
                            end
                            if not f then
                                rlePath = "/VIDEO/" .. name .. ".rle"
                                f = io.open(rlePath, "rb")
                                end
                                if not f then return false end

                                    -- 2. Locate Audio File (Short paths checked first to stay under 40 char limit)
                                    local wavCandidates = {
                                        "/VIDEO/" .. name .. "/audio.wav",   -- Best & safest (< 40 chars)
                                        "/VIDEO/" .. name .. "/" .. name .. ".wav",
                                        "/VIDEO/" .. name .. ".wav",
                                        "/VIDEO/" .. name .. "/AUDIO/" .. name .. ".wav"
                                    }
                                    local wavPath = nil
                                    for _, path in ipairs(wavCandidates) do
                                        local test = io.open(path, "rb")
                                        if test then
                                            io.close(test)
                                            wavPath = path
                                            break
                                            end
                                            end

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

                                                    if wavPath then
                                                        playFile(wavPath)
                                                        end

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

                                                        -- READ PHYSICAL SWITCH "SA" (Top-Left) For Looping
                                                        local sa_val = getValue("sa")
                                                        if sa_val and sa_val > 0 then
                                                            loopVideo = true
                                                            else
                                                                loopVideo = false
                                                                end

                                                                -- READ PHYSICAL SWITCH "SD" (Top-Right) For Auto-Next
                                                                local sd_val = getValue("sd")
                                                                if sd_val and sd_val > 0 then
                                                                    autoNext = true
                                                                    else
                                                                        autoNext = false
                                                                        end

                                                                        -- EXIT LOGIC
                                                                        if event == EVT_EXIT_BREAK then
                                                                            playFile("")
                                                                            if state == STATE_PLAYING or state == STATE_FINISHED then
                                                                                if f then io.close(f); f = nil end
                                                                                    state = STATE_MENU
                                                                                    collectgarbage()
                                                                                    return 0
                                                                                    else
                                                                                        return 1
                                                                                        end
                                                                                        end

                                                                                        -- ==========================================
                                                                                        -- SPLASH SCREEN STATE
                                                                                        -- ==========================================
                                                                                        if state == STATE_SPLASH then
                                                                                            if splashTime == 0 then splashTime = getTime() end

                                                                                                lcd.drawRectangle(34, 16, 60, 36, SOLID)
                                                                                                lcd.drawRectangle(36, 18, 56, 32, SOLID)
                                                                                                lcd.drawLine(64, 16, 50, 4, SOLID, 0)
                                                                                                lcd.drawLine(64, 16, 78, 4, SOLID, 0)

                                                                                                lcd.drawText(46, 24, "EdgeTV", 0)
                                                                                                lcd.drawText(50, 36, "v3.1", 0)

                                                                                                if getTime() - splashTime > 200 then
                                                                                                    state = STATE_MENU
                                                                                                    end

                                                                                                    -- ==========================================
                                                                                                    -- MENU STATE
                                                                                                    -- ==========================================
                                                                                                    elseif state == STATE_MENU then
                                                                                                        if event == EVT_ROT_RIGHT or event == EVT_MINUS_BREAK or event == EVT_DOWN_BREAK then
                                                                                                            selectedIndex = selectedIndex + 1
                                                                                                            if selectedIndex > #playlist then selectedIndex = 1 end
                                                                                                                elseif event == EVT_ROT_LEFT or event == EVT_PLUS_BREAK or event == EVT_UP_BREAK then
                                                                                                                    selectedIndex = selectedIndex - 1
                                                                                                                    if selectedIndex < 1 then selectedIndex = #playlist end
                                                                                                                        elseif event == EVT_ENTER_BREAK then
                                                                                                                            startVideo(playlist[selectedIndex])
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
                                                                                                                                                    local loopStr = loopVideo and "ON " or "OFF"
                                                                                                                                                    local autoStr = autoNext and "ON " or "OFF"
                                                                                                                                                    lcd.drawText(1, 56, "[SA]Lp:"..loopStr.." [SD]Auto:"..autoStr, 0)

                                                                                                                                                    -- ==========================================
                                                                                                                                                    -- PLAYING STATE
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

                                                                                                                                                                        if len > 3500 then
                                                                                                                                                                            state = STATE_MENU; if f then io.close(f); f = nil end; break
                                                                                                                                                                            end

                                                                                                                                                                            if len > 0 then
                                                                                                                                                                                local data = io.read(f, len)
                                                                                                                                                                                if currentFrame == targetFrame - 1 then
                                                                                                                                                                                    currentData = data
                                                                                                                                                                                    end
                                                                                                                                                                                    else
                                                                                                                                                                                        if currentFrame == targetFrame - 1 then
                                                                                                                                                                                            currentData = ""
                                                                                                                                                                                            end
                                                                                                                                                                                            end

                                                                                                                                                                                            currentFrame = currentFrame + 1
                                                                                                                                                                                            end
                                                                                                                                                                                            end

                                                                                                                                                                                            if state == STATE_PLAYING and currentData and #currentData > 0 then
                                                                                                                                                                                                local lines = 0
                                                                                                                                                                                                for i = 1, #currentData, 3 do
                                                                                                                                                                                                    local y, x1, x2 = string.byte(currentData, i, i+2)
                                                                                                                                                                                                    lcd.drawLine(x1, y, x2, y, SOLID, 0)
                                                                                                                                                                                                    lines = lines + 1
                                                                                                                                                                                                    if lines > MAX_LINES_PER_FRAME then break end
                                                                                                                                                                                                        end
                                                                                                                                                                                                        end

                                                                                                                                                                                                        if state == STATE_PLAYING and totalFrames > 0 then
                                                                                                                                                                                                            local p = math.floor((currentFrame / totalFrames) * 128)
                                                                                                                                                                                                            lcd.drawLine(0, 63, math.min(p, 128), 63, SOLID, 0)
                                                                                                                                                                                                            lcd.drawLine(0, 62, math.min(p, 128), 62, SOLID, 0)
                                                                                                                                                                                                            end

                                                                                                                                                                                                            -- ==========================================
                                                                                                                                                                                                            -- FINISHED STATE (BINGE LOGIC)
                                                                                                                                                                                                            -- ==========================================
                                                                                                                                                                                                            elseif state == STATE_FINISHED then
                                                                                                                                                                                                                if loopVideo then
                                                                                                                                                                                                                    startVideo(playlist[selectedIndex])
                                                                                                                                                                                                                    elseif autoNext then
                                                                                                                                                                                                                        selectedIndex = selectedIndex + 1
                                                                                                                                                                                                                        if selectedIndex > #playlist then selectedIndex = 1 end
                                                                                                                                                                                                                            startVideo(playlist[selectedIndex])
                                                                                                                                                                                                                            else
                                                                                                                                                                                                                                state = STATE_MENU
                                                                                                                                                                                                                                collectgarbage()
                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                return 0
                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                return { run = run }
