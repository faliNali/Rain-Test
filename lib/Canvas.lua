local Canvas = {}
Canvas.__index = Canvas

function Canvas.new(scale)
    local self = setmetatable({}, Canvas)
    local windowWidth, windowHeight = love.graphics.getDimensions()
    self._scale = scale
    self._width, self._height = windowWidth / scale, windowHeight / scale
    self._canvas = love.graphics.newCanvas(self.width, self.height)
    self._canvas:setFilter('nearest', 'nearest')

    return self
end

function Canvas:drawInto(drawFunction)
    love.graphics.setCanvas(self._canvas)
    love.graphics.clear()
    drawFunction()
    love.graphics.setCanvas()
end

function Canvas:draw()
    love.graphics.draw(self._canvas, 0, 0, 0, self._scale, self._scale)
end

function Canvas:getWidth() return self._width end
function Canvas:getHeight() return self._height end
function Canvas:getDimensions() return self._width, self._height end

return Canvas