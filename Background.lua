local drawFunctions = require "drawFunctions"
local Timer         = require "lib.Timer"
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
    self.skySquareSpeed = 15
    for i=1, 40 do
        self:newSkySquare()
    end

    self.newStarTimer = Timer.new(0.1, true, true)
    self.stars = {}
    self.starMaxWidth = 5
    self.starSpeed = 30
    self.starXOffset = 6
    self.starXRadianSpeed = 3
    self.starAlphaRadianSpeed = 3
    self.starWidthTimerDuration = 0.4

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

function Background:drawMoonAndRings()
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

function Background:newSkySquare()
    local square = {}
    square.width = math.random(20, 50)
    square.x = math.random(0, self.canvas:getWidth())
    square.y = math.random(0, self.groundY)

    local angle = math.random() * math.pi*2

    square.xVelocity = math.cos(angle) * self.skySquareSpeed
    square.yVelocity = math.sin(angle) * self.skySquareSpeed

    table.insert(self.skySquares, square)
end

function Background:newStar()
    local star = {}
    
    star.xRadianOffset = math.random() * math.pi*2
    star.alphaRadianOffset = math.random() * math.pi*2
    star.width = math.random(1, self.starMaxWidth)
    star.widthTimer = Timer.new(self.starWidthTimerDuration, true, true)
    star.x = math.random(star.width, self.canvas:getWidth())
    star.y = -star.width

    table.insert(self.stars, star)
end

function Background:drawSky()
    love.graphics.setColor(0.5, 0.2, 1, 0.25)
    love.graphics.rectangle('fill', 0, 0, self.canvas:getWidth(), self.groundY)
    love.graphics.setColor(1, 1, 1, 0.08)
    for _, square in ipairs(self.skySquares) do
        love.graphics.rectangle('fill', square.x, square.y, square.width, square.width)
    end
    love.graphics.setColor(1, 1, 1, 1)
    for _, star in ipairs(self.stars) do
        love.graphics.setColor(1, 1, 1, 1 - math.sin(star.alphaRadianOffset))
        local x = star.x + math.cos(star.xRadianOffset) * self.starXOffset
        love.graphics.line(
            x-star.width/2, star.y,
            x+star.width/2, star.y
        )
        love.graphics.line(
            x, star.y-star.width/2,
            x, star.y+star.width/2
        )
    end
end

function Background:draw()
    self:drawSky()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle(
        'fill',
        0,
        self.groundY,
        self.canvas:getWidth(), 
        self.canvas:getHeight()-self.groundY
    )
    self:drawOcean()
    self:drawMoonAndRings()
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

    self.newStarTimer:update(dt)
    if self.newStarTimer:isFinished() then
        self:newStar()
    end

    for i, star in ipairs(self.stars) do
        star.y = star.y + self.starSpeed * dt
        if star.y > self.groundY + star.width/2 then
            table.remove(self.stars, i)
        end

        star.widthTimer:update(dt)
        if star.widthTimer:isFinished() then
            star.width = star.width % self.starMaxWidth + 2
        end
        star.xRadianOffset = star.xRadianOffset + self.starXRadianSpeed*dt
        star.alphaRadianOffset = star.alphaRadianOffset + self.starAlphaRadianSpeed*dt
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