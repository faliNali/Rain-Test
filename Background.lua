local drawFunctions = require "drawFunctions"
local Background = {}
Background.__index = Background

function Background.new(canvas, groundY)
    local self = setmetatable({}, Background)

    self.canvas = canvas
    self.groundY = groundY
    self.radians = 0
    self.slowerRadians = 0

    self.moonX = canvas:getWidth()*0.5
    self.moonY = self.canvas:getHeight()*0.2
    self.numOfMoonRings = 3

    return self
end

function Background:drawOcean()
    local y = self.groundY
    local i = 0
    while y < self.canvas:getHeight() do
        love.graphics.setColor(1, 1, 1, i/50 + 0.15)
        i = i + 1
        y = y + 3
        local width = self.canvas:getWidth() / i^0.6
        local radiansOffset = math.sin(self.radians+ i*math.pi/15)*10
        love.graphics.line(
            self.canvas:getWidth() - width + radiansOffset,
            y,
            self.canvas:getWidth(),
            y
        )
    end
    love.graphics.setColor(1, 1, 1)
end

function Background:drawMoon()
    love.graphics.setColor(1, 1, 1)
    local r = self.radians
    love.graphics.circle(
        'fill', self.moonX + math.cos(r), self.moonY + math.sin(r), 20
    )
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle('fill', self.moonX-5+math.sin(r), self.moonY-3+math.cos(r), 15)
end

function Background:drawRings()
    for i=1, self.numOfMoonRings do
        love.graphics.setColor(1, 1, 1, 1-i/(self.numOfMoonRings+1))
        local radiusMultiplier = i^0.35 + math.sin(self.radians + i)*0.05
        drawFunctions.drawOval(
            self.moonX,
            self.moonY,
            35 * radiusMultiplier + math.cos(self.slowerRadians)*5,
            10 * radiusMultiplier + math.sin(self.slowerRadians)*5,
            0.4,
            20
        )
    end
end

function Background:draw()
    self:drawOcean()
    love.graphics.stencil(function()
        love.graphics.polygon(
            'fill',
            self.moonX - 50, self.moonY - 20,
            self.moonX + 20, self.moonY - 30,
            self.moonX + 50, self.moonY + 20
        )
    end, 'replace', 1)

    love.graphics.setStencilTest('equal', 1)
    self:drawRings()
    love.graphics.setStencilTest()
    self:drawMoon()
    love.graphics.setStencilTest('notequal', 1)
    self:drawRings()
    love.graphics.setStencilTest()
    -- love.graphics.polygon(
    --         'line',
    --         self.moonX - 50, self.moonY - 20,
    --         self.moonX + 20, self.moonY - 30,
    --         self.moonX + 50, self.moonY + 20
    --     )
end

function Background:update(dt)
    self.radians = self.radians + dt
    if self.radians >= math.pi*2 then
        self.radians = self.radians - math.pi*2
    end
    self.slowerRadians = self.slowerRadians + dt/3
    if self.slowerRadians >= math.pi*2 then
        self.slowerRadians = self.slowerRadians - math.pi*2
    end
end

return Background