local drawFunctions = {}

function drawFunctions.drawOval(drawMode, x, y, width, height, rotation, numOfSegments)
    local coordinates = {}
    rotation = rotation or 0
    numOfSegments = numOfSegments or 8
    for i=1, numOfSegments do
        local radian = i/numOfSegments * math.pi*2
        local originX, originY = math.cos(radian)*width, math.sin(radian)*height
        local rotatedX = originX*math.cos(rotation) - originY*math.sin(rotation)
        local rotatedY = originX*math.sin(rotation) + originY*math.cos(rotation)

        table.insert(coordinates, rotatedX + x)
        table.insert(coordinates, rotatedY + y)
    end
    love.graphics.polygon(drawMode, coordinates)
end

function drawFunctions.getRandomRainColor()
    local colors = {}
    for _=1, 3 do
        table.insert(colors, math.random(150, 255)/255)
    end
    return colors
end

return drawFunctions