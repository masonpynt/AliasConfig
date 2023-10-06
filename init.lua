-- Define the alias path
local aliasPath = "/Users/" .. os.getenv("USER") .. "/Desktop/Main Data Files alias"

-- AppleScript for renaming folder
local applescript = [[
    set aliasPath to (path to desktop folder as text) & "Main Data Files alias"
    set newAliasName to "Main Data Files"
    tell application "Finder"
        set name of folder aliasPath to newAliasName
    end tell
]]

-- Global Variables for Sleep Time
local systemSleepTime = 0
local displaySleepTime = 0


-- Function to be called when the system wakes up
function handleSystemWake(sleptDuration)
    os.execute("/usr/local/bin/.wakeup")
    if sleptDuration > 21600 then -- 6 hours * 60 minutes * 60 seconds
        os.execute("killall 'Google Drive'")
        hs.timer.doAfter(3, function()
            os.execute("open -a 'Google Drive'")
        end)
    end
end

function handleDisplayWake(displaySleptDuration)
    os.execute("/usr/local/bin/.wakeup")
    if displaySleptDuration > 21600 then
        os.execute("killall 'Google Drive'")
        hs.timer.doAfter(3, function() 
            os.execute("open -a 'Google Drive'")
        end)
    end
end

-- Register sleep and wake event
hs.caffeinate.watcher.new(function(eventType)
    if eventType == hs.caffeinate.watcher.systemDidWake then
        handleSystemWake()
    elseif eventType == hs.caffeinate.watcher.screensDidWake then
        handleDisplayWake()
    end
end):start()

hs.pathwatcher.new(aliasPath, function(files)
    for _, file in ipairs(files) do
        if file == aliasPath then
            hs.osascript.applescript(applescript) -- Run the AppleScript to rename the alias
            hs.execute("mv '" .. aliasPath .. "' '/Users/" .. os.getenv("USER") .. "/Desktop/Main Data Files'")
        end
    end
end):start()

