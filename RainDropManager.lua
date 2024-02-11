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
    local rainDrop = RainDrop.new(x, y, math.random(self.groundY, self.canvas:getHeight()))
    table.insert(self.rainDrops, rainDrop)
end

function RainDropManager:update(dt)
    self.timer:update(dt)

    if self.timer:isFinished() then
        for _=1, 5 do
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
function RainDropManager:draw(yRangeStart, yRangeEnd)
    yRangeStart = yRangeStart or 0
    yRangeEnd = yRangeEnd or self.canvas:getHeight()

    for _, rainDrop in ipairs(self.rainDrops) do
        if rainDrop.yPopPosition < yRangeStart or rainDrop.yPopPosition > yRangeEnd then
            goto continue
        end

        local r, g, b= unpack(rainDrop.color)
        local groundYLerpPosition = (rainDrop.yPopPosition-self.groundY)/(self.canvas:getHeight()-self.groundY)
        local alpha = math.min(groundYLerpPosition + 0.3, 1)
        local sizeFactor = math.min(groundYLerpPosition + 0.5, 1)

        local x, y = rainDrop:getPosition()

        if rainDrop.popped then
            local duration = rainDrop.durationPopped
            love.graphics.setColor(r, g, b, alpha * (self.durationPoppedSpan-duration))
            local ovalSizeFactor = duration^0.5 * sizeFactor * 3
            drawFunctions.drawOval('line', x, y, ovalSizeFactor*2, ovalSizeFactor)
        else
            love.graphics.setColor(r, g, b, alpha)
            local rainDropSizeFactor = self.rainDropSize * sizeFactor
            love.graphics.line(
                x, y,
                x-math.cos(rainDrop.angle)*rainDropSizeFactor,
                y-math.sin(rainDrop.angle)*rainDropSizeFactor
            )
        end
        ::continue::
    end
    love.graphics.setColor(1, 1, 1)
end

return RainDropManager