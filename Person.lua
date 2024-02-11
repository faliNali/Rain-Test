local anim8 = require 'lib.vendor.anim8'
local Timer = require 'lib.Timer'
local drawFunctions = require 'drawFunctions'

local Person = {}
Person.__index = Person

function Person.new(canvas)
    local self = setmetatable({}, Person)
    self.canvas = canvas

    self.sprite = love.graphics.newImage('sprites/person-Sheet.png')
    local frameWidth = 64
    local person_grid = anim8.newGrid(
        frameWidth, frameWidth, self.sprite:getWidth(), self.sprite:getHeight()
    )
    self.anim =  anim8.newAnimation(person_grid('1-4', 1), 0.5)

    self.position = {
        x = (canvas:getWidth() - frameWidth)/2,
        y = (canvas:getHeight() - frameWidth)/2 + 22
    }

    local pp = self.position
    self.realYPosition = pp.y + self.sprite:getHeight() - 10
    self.umbrellaRects = {
        {pp.x+14, pp.y+18, 18, 12},
        {pp.x+19, pp.y+12, 20, 12}
    }
    self.umbrellaRainTimer = Timer.new(0.5, true, true)
    self.umbrellaRainDrops = {}

    return self
end

function Person:update(dt)
    self.anim:update(dt)
    self.umbrellaRainTimer:update(dt)

    if self.umbrellaRainTimer:isFinished() then
        local rect = math.random() > 0.5 and self.umbrellaRects[1] or self.umbrellaRects[2]
        local x = rect[1] + math.random()*rect[3]
        local y = rect[2] + math.random()*rect[4]
        local rainDrop = {
            x=x,
            y=y,
            timer = Timer.new(1, true, false),
            color = drawFunctions.getRandomRainColor()
        }
        table.insert(self.umbrellaRainDrops, rainDrop)
    end

    for i, rainDrop in ipairs(self.umbrellaRainDrops) do
        rainDrop.y = rainDrop.y + dt*3
        rainDrop.timer:update(dt)
        if rainDrop.timer:isFinished() then
            table.remove(self.umbrellaRainDrops, i)
        end
    end

end

function Person:draw()
    self.anim:draw(self.sprite, self.position.x, self.position.y)

    for _, rainDrop in ipairs(self.umbrellaRainDrops) do
        local r, g, b = unpack(rainDrop.color)
        local timer = rainDrop.timer
        love.graphics.setColor(r, g, b, timer.count / timer.maxDuration)
        love.graphics.line(rainDrop.x, rainDrop.y, rainDrop.x, rainDrop.y + 3)
    end
    love.graphics.setColor(1, 1, 1)
end

return Person