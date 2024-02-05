local Canvas = require 'lib.Canvas'
local RainDropManager = require 'RainDropManager'

local canvas
local rainDropManager
local groundY = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setLineStyle('rough')

    canvas = Canvas.new(4)

    local groundY = canvas:getHeight()*0.4
    rainDropManager = RainDropManager.new(canvas, groundY)
end

local function canvasDraw()
    rainDropManager:draw()
    --[[ for i=0, 10 do
        local color = 0.1 + 0.05*i
        love.graphics.setColor(color, color, color)
        local y = canvas:getHeight()*0.6 + 1.5^i
        love.graphics.rectangle('fill', 0, y, canvas:getWidth(), canvas:getHeight()-y)
    end
    love.graphics.setColor(1, 1, 1) ]]
    love.graphics.line(0, groundY, canvas:getWidth(), groundY)

    rainDropManager:draw()
end

function love.update(dt)
    rainDropManager:update(dt)

    canvas:drawInto(canvasDraw)
end

function love.draw()
    canvas:draw()
end