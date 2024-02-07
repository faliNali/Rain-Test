local Canvas = require 'lib.Canvas'
local RainDropManager = require 'RainDropManager'
local Background = require 'Background'

local canvas
local rainDropManager
local background
local groundY = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    canvas = Canvas.new(4)

    groundY = canvas:getHeight()*0.4
    rainDropManager = RainDropManager.new(canvas, groundY)
    background = Background.new(canvas, groundY)
end

local function canvasDraw()
    background:draw()
    rainDropManager:draw()

    --love.graphics.rectangle('line', 10, 10, 25, 50)
end

function love.update(dt)
    rainDropManager:update(dt)
    background:update(dt)

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