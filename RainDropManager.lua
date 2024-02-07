local Timer = require 'lib.Timer'
local RainDrop = require 'RainDrop'
local drawFunctions = require 'drawFunctions'

local RainDropManager = {}
RainDropManager.__index = RainDropManager

function RainDropManager.new(canvas, groundY)
    local self = setmetatable({}, RainDropManager)

    self.timer = Timer.new(0.02, true, true)
    self.rainDrops = {}
    self.canvas = canvas
    self.groundY = groundY
    self.durationPoppedSpan = 1
    self.rainDropSize = 8

    return self
end

function RainDropManager:newRainDrop()
    local x, y = math.random(-self.canvas:getHeight(), self.canvas:getWidth()), 0
    table.insert(
        self.rainDrops,
        RainDrop.new(x, y, math.random(self.groundY, self.canvas:getHeight()))
    )
end

function RainDropManager:update(dt)
    self.timer:update(dt)

    if self.timer:isFinished() then
        for _=1, 6 do
            self:newRainDrop()
        end
    end

    for i, rainDrop in ipairs(self.rainDrops) do
        rainDrop:update(dt)

        if rainDrop.durationPopped > self.durationPoppedSpan then
            table.remove(self.rainDrops, i)
        end
    end
end

function RainDropManager:draw()
    for _, rainDrop in ipairs(self.rainDrops) do
        local groundYLerpPosition = (rainDrop.yPopPosition-self.groundY)/(self.canvas:getHeight()-self.groundY)
        local alpha = math.min(groundYLerpPosition + 0.25, 1)
        local sizeFactor = math.min(groundYLerpPosition + 0.5, 1)
        
        local x, y = rainDrop:getPosition()
        if rainDrop.popped then
            local duration = rainDrop.durationPopped
            love.graphics.setColor(1, 1, 1, alpha * (self.durationPoppedSpan-duration))
            local ovalSizeFactor = duration^0.5 * sizeFactor * 3
            drawFunctions.drawOval(x, y, ovalSizeFactor*2, ovalSizeFactor)
        else
            love.graphics.setColor(1, 1, 1, alpha)
            local rainDropSizeFactor = self.rainDropSize * sizeFactor
            love.graphics.line(
                x, y,
                x-math.cos(rainDrop.angle)*rainDropSizeFactor,
                y-math.sin(rainDrop.angle)*rainDropSizeFactor
            )
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return RainDropManager