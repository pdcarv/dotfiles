-- Hammerspoon Configuration
-- Save this as ~/.hammerspoon/init.lua

-- Reload configuration automatically when files change
function reloadConfig(files)
    local doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon config loaded")

-- ========== CONFIGURATION ==========
-- Modifier keys
local hyper = {"ctrl", "alt"}
local appHotkey = {"alt"}

-- Window animation duration (set to 0 for instant)
hs.window.animationDuration = 0.1

-- Grid for window placement
hs.grid.setGrid('12x12')
hs.grid.setMargins({0, 0})

-- ========== APPLICATION SHORTCUTS ==========
-- Function to focus app or launch if not running
function focusApp(appName)
    return function()
        local app = hs.application.find(appName)
        if app then
            if app:isFrontmost() then
                app:hide()
            else
                app:activate()
            end
        else
            hs.application.launchOrFocus(appName)
        end
    end
end

-- App bindings
hs.hotkey.bind(appHotkey, "b", focusApp("Safari"))
hs.hotkey.bind(appHotkey, "t", focusApp("Ghostty"))
hs.hotkey.bind(appHotkey, "c", focusApp("Visual Studio Code"))
hs.hotkey.bind(appHotkey, "o", focusApp("Obsidian"))
hs.hotkey.bind(appHotkey, "a", focusApp("Calendar"))
hs.hotkey.bind(appHotkey, "r", focusApp("Reminders"))

-- ========== WINDOW MANAGEMENT ==========
-- Position active window in the specified direction
function moveWindow(direction)
    return function()
        local win = hs.window.focusedWindow()
        if not win then return end
        
        local f = win:frame()
        local screen = win:screen()
        local max = screen:frame()
        
        if direction == "left" then
            f.x = max.x
            f.y = max.y
            f.w = max.w / 2
            f.h = max.h
        elseif direction == "right" then
            f.x = max.x + (max.w / 2)
            f.y = max.y
            f.w = max.w / 2
            f.h = max.h
        elseif direction == "top" then
            f.x = max.x
            f.y = max.y
            f.w = max.w
            f.h = max.h / 2
        elseif direction == "bottom" then
            f.x = max.x
            f.y = max.y + (max.h / 2)
            f.w = max.w
            f.h = max.h / 2
        elseif direction == "topLeft" then
            f.x = max.x
            f.y = max.y
            f.w = max.w / 2
            f.h = max.h / 2
        elseif direction == "topRight" then
            f.x = max.x + (max.w / 2)
            f.y = max.y
            f.w = max.w / 2
            f.h = max.h / 2
        elseif direction == "bottomLeft" then
            f.x = max.x
            f.y = max.y + (max.h / 2)
            f.w = max.w / 2
            f.h = max.h / 2
        elseif direction == "bottomRight" then
            f.x = max.x + (max.w / 2)
            f.y = max.y + (max.h / 2)
            f.w = max.w / 2
            f.h = max.h / 2
        elseif direction == "maximize" then
            f = max
        elseif direction == "center" then
            f.x = max.x + (max.w * 0.125)
            f.y = max.y + (max.h * 0.125)
            f.w = max.w * 0.75
            f.h = max.h * 0.75
        end
        
        win:setFrame(f)
    end
end

-- Window movement to other screens
function moveToScreen(direction)
    return function()
        local win = hs.window.focusedWindow()
        if not win then return end
        
        if direction == "next" then
            win:moveToScreen(win:screen():next())
        elseif direction == "prev" then
            win:moveToScreen(win:screen():previous())
        end
        win:maximize()
    end
end

-- Window management hotkeys
-- Halves
hs.hotkey.bind(hyper, "h", moveWindow("left"))
hs.hotkey.bind(hyper, "l", moveWindow("right"))
hs.hotkey.bind(hyper, "k", moveWindow("top"))
hs.hotkey.bind(hyper, "j", moveWindow("bottom"))

-- Corners
hs.hotkey.bind(hyper, "u", moveWindow("topLeft"))
hs.hotkey.bind(hyper, "i", moveWindow("topRight"))
hs.hotkey.bind(hyper, "n", moveWindow("bottomLeft"))
hs.hotkey.bind(hyper, "m", moveWindow("bottomRight"))

-- Full and center
hs.hotkey.bind(hyper, "f", moveWindow("maximize"))
hs.hotkey.bind(hyper, "c", moveWindow("center"))

-- Move between screens
hs.hotkey.bind(hyper, "right", moveToScreen("next"))
hs.hotkey.bind(hyper, "left", moveToScreen("prev"))

-- Resize window (similar to Rectangle's resize options)
function resizeWindow(direction, amount)
    return function()
        local win = hs.window.focusedWindow()
        if not win then return end
        
        local f = win:frame()
        
        if direction == "wider" then
            f.w = f.w + amount
        elseif direction == "narrower" then
            f.w = f.w - amount
        elseif direction == "taller" then
            f.h = f.h + amount
        elseif direction == "shorter" then
            f.h = f.h - amount
        end
        
        win:setFrame(f)
    end
end

-- Resize window hotkeys
hs.hotkey.bind({"shift", "ctrl", "alt"}, "h", resizeWindow("narrower", 50))
hs.hotkey.bind({"shift", "ctrl", "alt"}, "l", resizeWindow("wider", 50))
hs.hotkey.bind({"shift", "ctrl", "alt"}, "j", resizeWindow("taller", 50))
hs.hotkey.bind({"shift", "ctrl", "alt"}, "k", resizeWindow("shorter", 50))

-- ========== WINDOW HINTS (for easy jumping between windows) ==========
hs.hotkey.bind({"alt"}, "space", function() 
    hs.hints.windowHints()
end)

-- Window focus navigation (vim-style)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "h", function() hs.window.focusedWindow():focusWindowWest() end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "l", function() hs.window.focusedWindow():focusWindowEast() end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "k", function() hs.window.focusedWindow():focusWindowNorth() end)
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "j", function() hs.window.focusedWindow():focusWindowSouth() end)
