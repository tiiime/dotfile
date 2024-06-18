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
    hs.alert.show("zoom!")
    -- run shell cmd
    yabaiRun({"-m", "window", "--toggle", "zoom-fullscreen"})
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
function Yabai.autoRaise(enable)
    if enable then
        yabaiRun({"-m", "config", "focus_follows_mouse", "autoraise"})
    else
        yabaiRun({"-m", "config", "focus_follows_mouse", "off"})
    end
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

return Yabai
