--[[
    things to work on:
        - adding sky background
        - making rings go behind moon (done)
        - adding colors
]]

local Canvas = require 'lib.Canvas'
local RainDropManager = require 'RainDropManager'
local Background = require 'Background'
local Person = require 'Person'

local canvas
local rainDropManager
local background
local person
local groundY = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    canvas = Canvas.new(4)

    groundY = canvas:getHeight()*0.4
    rainDropManager = RainDropManager.new(canvas, groundY)
    background = Background.new(canvas, groundY)
    person = Person.new(canvas)
end

local function canvasDraw()
    background:draw()
    love.graphics.setColor(1, 1, 1)
    rainDropManager:draw(0, person.realYPosition)
    person:draw()
    rainDropManager:draw(person.realYPosition)
end

function love.update(dt)
    rainDropManager:update(dt)
    background:update(dt)
    person:update(dt)

    canvas:drawInto(canvasDraw)
end

function love.keypressed(key)
    if key == 'q' then love.event.quit() end
end

function love.draw()
    canvas:draw()
end

function love.resize()
    love.load()
end