local yabai = require('yabai.init')
local SecondStroke = require('SecondStroke.init')

-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", hawkeye.alert)
-- hs.hotkey.bind({"shift", "ctrl"}, "space", hawkeye.queryHawkeye)

hs.hotkey.bind({"option"}, "f", yabai.toggleZoom)
hs.hotkey.bind({"option"}, "x", yabai.mirrorX)
hs.hotkey.bind({"option"}, "y", yabai.mirrorY)
hs.hotkey.bind({"option", "shift"}, "f", yabai.toggleFloat)
hs.hotkey.bind({"option"}, "r", yabai.rotateLayout)
hs.hotkey.bind({"option"}, "n", yabai.stackFocusNext)
hs.hotkey.bind({"option"}, "p", yabai.stackFocusPrev)
hs.hotkey.bind({"option"}, "`", yabai.stackFocusLoop)

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
    yabai.toggleAutoRaise()
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
    mods = {"option", "shift"},
    key = "up",
    value = function()
        yabai.swapWindowTo("north")
    end
}, {
    mods = {"option", "shift"},
    key = "right",
    value = function()
        yabai.swapWindowTo("east")
    end
}, {
    mods = {"option", "shift"},
    key = "down",
    value = function()
        yabai.swapWindowTo("south")
    end
}, {
    mods = {"option", "shift"},
    key = "left",
    value = function()
        yabai.swapWindowTo("west")
    end
}, {
    mods = {"option"},
    key = "up",
    value = function()
        yabai.moveFocusToWindow("north")
    end
}, {
    mods = {"option"},
    key = "right",
    value = function()
        yabai.moveFocusToWindow("east")
    end
}, {
    mods = {"option"},
    key = "down",
    value = function()
        yabai.moveFocusToWindow("south")
    end
}, {
    mods = {"option"},
    key = "left",
    value = function()
        yabai.moveFocusToWindow("west")
    end
}, {
    mods = {"shift"},
    key = "up",
    value = function()
        yabai.resizeWindow("up")
    end
}, {
    mods = {"shift"},
    key = "right",
    value = function()
        yabai.resizeWindow("right")
    end
}, {
    mods = {"shift"},
    key = "down",
    value = function()
        yabai.resizeWindow("down")
    end
}, {
    mods = {"shift"},
    key = "left",
    value = function()
        yabai.resizeWindow("left")
    end
}, {
    mods = {},
    key = "r",
    value = function()
        hs.alert.show("Config reloaded")
        -- delay 1s
        hs.timer.doAfter(1, function()
            hs.reload()
        end)
    end
}, {
    mods = {},
    key = "s",
    value = function()
        yabai.stickyWindow()
    end
}}

optionS_second = SecondStroke:new({"option", "s"}, option_s_map)
optionS_second:start()

hs.hotkey.bind({"ctrl"}, "`", function()
    local app = hs.application.get("kitty")

    if app then
        if not app:mainWindow() then
            app:selectMenuItem({"kitty", "New OS window"})
        elseif app:isFrontmost() then
            app:hide()
        else
            app:activate()
        end
    else
        hs.application.launchOrFocus("kitty")
        app = hs.application.get("kitty")
    end


    app:mainWindow():moveToUnit '[99,99,0.5,0.5]'
    app:mainWindow().setShadows(false)
end)
