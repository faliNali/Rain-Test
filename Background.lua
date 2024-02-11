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

    self.skySquares = {}
    for i=1, 40 do
        self:newSkySquare()
    end

    return self
end

function Background:newSkySquare()
    local square = {}
    square.width = math.random(20, 50)
    square.x = math.random(0, self.canvas:getWidth())
    square.y = math.random(0, self.groundY)

    local angle = math.random() * math.pi*2
    local speed = 15

    square.xVelocity = math.cos(angle) * speed
    square.yVelocity = math.sin(angle) * speed

    table.insert(self.skySquares, square)
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
            'line',
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
    love.graphics.setColor(0.5, 0.2, 1, 0.25)
    love.graphics.rectangle('fill', 0, 0, self.canvas:getWidth(), self.groundY)
    love.graphics.setColor(1, 1, 1, 0.08)
    for _, square in ipairs(self.skySquares) do
        love.graphics.rectangle('fill', square.x, square.y, square.width, square.width)
    end
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, self.groundY, self.canvas:getWidth(), self.canvas:getHeight()-self.groundY)
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

    for i, square in ipairs(self.skySquares) do
        square.x = square.x + square.xVelocity * dt
        square.y = square.y + square.yVelocity * dt

        if square.x < -square.width then square.x = self.canvas:getWidth() end
        if square.x > self.canvas:getWidth() then square.x = -square.width end
        if square.y < -square.width then square.y = self.groundY end
        if square.y > self.groundY then square.y = -square.width end
    end
end

return Background