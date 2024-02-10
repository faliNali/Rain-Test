--[[
    things to work on:
        - adding sky background
        - making rings go behind moon
        - adding colors
]]

local anim8 = require 'lib.vendor.anim8'
local Canvas = require 'lib.Canvas'
local RainDropManager = require 'RainDropManager'
local Background = require 'Background'

local canvas
local rainDropManager
local background
local groundY = 0

local person_sprite
local person_anim
local personPosition

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    canvas = Canvas.new(4)

    groundY = canvas:getHeight()*0.4
    rainDropManager = RainDropManager.new(canvas, groundY)
    background = Background.new(canvas, groundY)

    person_sprite = love.graphics.newImage('sprites/person-Sheet.png')
    local frameWidth = 64
    local person_grid = anim8.newGrid(
        frameWidth, frameWidth, person_sprite:getWidth(), person_sprite:getHeight()
    )
    person_anim = anim8.newAnimation(person_grid('1-4', 1), 0.5)
    personPosition = {
        x = (canvas:getWidth() - frameWidth)/2,
        y = (canvas:getHeight() - frameWidth)/2 + 22
    }
end

local function canvasDraw()
    -- love.graphics.setColor(0.3, 0.3, 0.3)
    -- love.graphics.rectangle('fill', 0, 0, canvas:getWidth(), groundY)
    background:draw()
    love.graphics.setColor(1, 1, 1)
    rainDropManager:draw()
    person_anim:draw(person_sprite, personPosition.x, personPosition.y)
end

function love.update(dt)
    rainDropManager:update(dt)
    background:update(dt)
    person_anim:update(dt)

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