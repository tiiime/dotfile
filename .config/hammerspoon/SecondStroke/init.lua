SecondStroke = {}
SecondStroke.__index = SecondStroke

-- 仿两次按键，触发事件
function SecondStroke:new(hyper_key, second_stroke_map)
    local instance = setmetatable({}, SecondStroke)
    instance.__hyper_key = hyper_key
    instance.__second_stroke_map = second_stroke_map
    instance.__key = {}
    return instance
end

function SecondStroke:enterHyperMode()
    hs.fnutils.map(self.__key, function(item)
        item:disable()
    end)
    self.__key = hs.fnutils.map(self.__second_stroke_map, function(item)
        return hs.hotkey.bind(item.mods, item.key, function()
            item.value()
        end)
    end)
end

function SecondStroke:exitHyperMode()
    hs.timer.doAfter(1, function()
        hs.fnutils.map(self.__key, function(item)
            item:disable()
        end)
    end)
end

function SecondStroke:start()
    hs.hotkey.bind(self.__hyper_key[1], self.__hyper_key[2], function()
        self:enterHyperMode()
    end, function()
        self:exitHyperMode()
    end)
end

return SecondStroke
