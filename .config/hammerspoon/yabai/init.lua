local Yabai = {}
local logger = require("hs.logger").new("Yabai", "info")

function yabaiRun(args, completion)
    local yabai_output = ""
    local yabai_error = ""
    -- Runs in background very fast
    local yabai_task = hs.task.new("~/.local/bin/yabai", function(err, stdout, stderr)
        print()
    end, function(task, stdout, stderr)
        -- print("stdout:"..stdout, "stderr:"..stderr)
        if stdout ~= nil then
            yabai_output = yabai_output .. stdout
        end
        if stderr ~= nil then
            yabai_error = yabai_error .. stderr
        end
        return true
    end, args)
    if type(completion) == "function" then
        yabai_task:setCallback(function()
            completion(yabai_output, yabai_error)
        end)
    end
    yabai_task:start()
end

function Yabai.alert()
    hs.alert.show("Hello World!")
end

function Yabai.toggleFloat()
    hs.alert.show("float!")
    -- run shell cmd
    yabaiRun({"-m", "window", "--toggle", "float"})
end

function Yabai.toggleZoom()
    -- run shell cmd
    -- yabai -m query --windows --window
    yabaiRun({"-m", "query", "--windows", "--window"}, function(output, error)
        local window = hs.json.decode(output)
        local zoomed = window["has-fullscreen-zoom"]
        if string.find(tostring(zoomed), "true") then
            hs.alert.show("zoom out!")
        else
            hs.alert.show("zoom in!")
        end
        yabaiRun({"-m", "window", "--toggle", "zoom-fullscreen"})
    end)
end

function Yabai.mirrorX()
    -- run shell cmd
    yabaiRun({"-m", "space", "--mirror", "x-axis"})
end
function Yabai.mirrorY()
    -- run shell cmd
    yabaiRun({"-m", "space", "--mirror", "y-axis"})
end

-- moveToSpace
function Yabai.moveToSpace(index)
    hs.alert.show("moveToSpace(" .. index .. ")")
    yabaiRun({"-m", "space", "--focus", tostring(index)})
end

-- #yabai -m config focus_follows_mouse autoraise
function Yabai.toggleAutoRaise()
    yabaiRun({"-m", "config", "focus_follows_mouse"}, function(output, error)
        if string.find(output, "autoraise") then
            hs.alert.show("focus_follows_mouse: off")
            yabaiRun({"-m", "config", "focus_follows_mouse", "off"})
        else
            hs.alert.show("focus_follows_mouse: auto-raise")
            yabaiRun({"-m", "config", "focus_follows_mouse", "autoraise"})
        end
    end)
end

function Yabai.toggleLayout()
    yabaiRun({"-m", "query", "--spaces", "--space"}, function(output, error)
        local space = hs.json.decode(output)
        local index = space["index"]
        if space["type"] == "bsp" then
            hs.alert.show("toggle layout: float")
            yabaiRun({"-m", "config", "--space", tostring(index), "layout", "float"})
        else
            hs.alert.show("toggle layout: bsp")
            yabaiRun({"-m", "config", "--space", tostring(index), "layout", "bsp"})
        end
    end)
end

-- 移动 window 到指定的 space
function Yabai.moveWindowToSpace(index)
    hs.alert.show("moveWindowToSpace(" .. index .. ")")
    yabaiRun({"-m", "window", "--space", tostring(index)})
end

-- 将当前 window 移动到到指定的位置
function Yabai.swapWindowTo(side)
    hs.alert.show("swapWindowTo(" .. side .. ")")
    yabaiRun({"-m", "window", "--swap", tostring(side)})
end

-- 将当前 window 移动到到指定的位置
function Yabai.moveFocusToWindow(side)
    hs.alert.show("moveFocusToWindow(" .. side .. ")")
    yabaiRun({"-m", "window", "--focus", tostring(side)})
end

-- 旋转 layout
function Yabai.rotateLayout()
    yabaiRun({"-m", "space", "--rotate", "270"})
end

-- 切换 stack focus next
function Yabai.stackFocusNext()
    hs.alert.show("stackFocusNext")
    yabaiRun({"-m", "window", "--focus", "stack.next"})
end
-- 切换 stack focus prev
function Yabai.stackFocusPrev()
    hs.alert.show("stackFocusPrev")
    yabaiRun({"-m", "window", "--focus", "stack.prev"})
end
-- 切换 stack focus loop
function Yabai.stackFocusLoop()
    hs.alert.show("stackFocusLoop")
    yabaiRun({"-m", "window", "--focus", "stack.next"}, function(output, error)
        if not (error == '') then
            yabaiRun({"-m", "window", "--focus", "stack.first"})
        end
    end)
end

-- 切换 stack focus loop
function Yabai.stickyWindow()
    hs.alert.show("stickyWindow")
    yabaiRun({"-m", "window", "--toggle", "sticky"})
end

-- resize window
function Yabai.resizeWindow(key)
    hs.alert.show("resizeWindow(" .. key .. ")")
    -- switch key
    local keyMap = {
        ["up"] = "bottom:0:-20",
        ["down"] = "bottom:0:20",
        ["left"] = "left:-20:0",
        ["right"] = "right:20:0"
    }
    yabaiRun({"-m", "window", "--resize", keyMap[key]})
end

return Yabai
