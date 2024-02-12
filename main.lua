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
local Timer  = require 'lib.Timer'

local handle_sprite
local handleOffset
local handleTimer

local canvas
local rainDropManager
local background
local person
local groundY = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')
    math.randomseed(os.time())

    handle_sprite = love.graphics.newImage('sprites/handle.png')
    handleOffset = {x=0, y=0}
    handleTimer = Timer.new(0.8, true, true)

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
    handleTimer:update(dt)
    if handleTimer:isFinished() then
        handleOffset.y = handleOffset.y == 3 and 0 or 3
    end
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
    love.graphics.draw(handle_sprite, handleOffset.x, handleOffset.y, 0, 2, 2)
end

function love.resize()
    love.load()
end