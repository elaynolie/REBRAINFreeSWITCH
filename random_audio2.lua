local math = require "math"
math.randomseed(os.time() + os.clock() * 100000)
local function play_random_tts(session)

    local tts_files = { 
            "/var/lib/freeswitch/sounds/tts1.wav",
            "/var/lib/freeswitch/sounds/tts2.wav",
            "/var/lib/freeswitch/sounds/tts3.wav"
    }


    math.randomseed(os.time())


    local random_index = math.random(1, #tts_files)
    local selected_tts_file = tts_files[random_index]


    session:streamFile(selected_tts_file)


    freeswitch.consoleLog("INFO", "Played TTS file: " .. selected_tts_file .. "\n")
end


if session then
    play_random_tts(session)
else
    freeswitch.consoleLog("ERR", "Session not found!\n")
end
