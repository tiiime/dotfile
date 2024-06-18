local yabai = require('yabai.init')
local SecondStroke = require('SecondStroke.init')
local actionMode = false

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", hawkeye.alert)
-- hs.hotkey.bind({"shift", "ctrl"}, "space", hawkeye.queryHawkeye)

hs.hotkey.bind({"option"}, "f", yabai.toggleZoom)
hs.hotkey.bind({"option"}, "x", yabai.mirrorX)
hs.hotkey.bind({"option"}, "y", yabai.mirrorY)
hs.hotkey.bind({"option", "shift"}, "f", yabai.toggleFloat)
hs.hotkey.bind({"option"}, "r", yabai.rotateLayout)

-- 将当前 space 切换到指定的 space
for i = 1, 5 do
    hs.hotkey.bind({"option"}, tostring(i), function()
        yabai.moveToSpace(i)
    end)
end
-- 将当前 window 移动到指定的 space
for i = 1, 5 do
    hs.hotkey.bind({"option", "shift"}, tostring(i), function()
        yabai.moveWindowToSpace(i)
    end)
end

-- 切换布局 config float/bsp
hs.hotkey.bind({"option"}, "t", function()
    -- hs.application.open("kitty")
    yabai.toggleLayout()
end)

-- 切换 autoRaise
hs.hotkey.bind({"option"}, "a", function()
    -- enter action mode
    actionMode = not actionMode
    yabai.autoRaise(actionMode)
    hs.alert.show("Toggle action mode: " .. tostring(actionMode))
end)

-- Cmd + Tab 只展示当前 space 的 window
switcher = hs.window.switcher.new(hs.window.filter.new():setCurrentSpace(true))
function mapCmdTab(event)
    local flags = event:getFlags()
    local chars = event:getCharacters()
    if chars == "\t" and flags:containExactly{'cmd'} then
        switcher:next()
        return true
    elseif chars == string.char(25) and flags:containExactly{'cmd', 'shift'} then
        switcher:previous()
        return true
    end
end
tapCmdTab = hs.eventtap.new({hs.eventtap.event.types.keyDown}, mapCmdTab)
tapCmdTab:start()

local option_s_map = {{
    mods = {"option"},
    key = "up",
    value = function()
        yabai.swapWindowTo("north")
    end
}, {
    mods = {"option"},
    key = "right",
    value = function()
        yabai.swapWindowTo("east")
    end
}, {
    mods = {"option"},
    key = "down",
    value = function()
        yabai.swapWindowTo("south")
    end
}, {
    mods = {"option"},
    key = "left",
    value = function()
        yabai.swapWindowTo("west")
    end
}, {
    mods = {},
    key = "up",
    value = function()
        yabai.moveFocusToWindow("north")
    end
}, {
    mods = {},
    key = "right",
    value = function()
        yabai.moveFocusToWindow("east")
    end
}, {
    mods = {},
    key = "down",
    value = function()
        yabai.moveFocusToWindow("south")
    end
}, {
    mods = {},
    key = "left",
    value = function()
        yabai.moveFocusToWindow("west")
    end
}}

optionS = SecondStroke:new({"option", "s"}, option_s_map)
optionS:start()
