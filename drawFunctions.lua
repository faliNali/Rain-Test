local drawFunctions = {}

function drawFunctions.drawOval(x, y, width, height, rotation, numOfSegments)
    local segments = {}
    rotation = rotation or 0
    numOfSegments = numOfSegments or 8
    for i=0, numOfSegments do
        local radian = i/numOfSegments * math.pi*2
        local originX, originY = math.cos(radian)*width, math.sin(radian)*height

        local rotatedX = originX*math.cos(rotation) - originY*math.sin(rotation)
        local rotatedY = originX*math.sin(rotation) + originY*math.cos(rotation)

        table.insert(segments, rotatedX + x)
        table.insert(segments, rotatedY + y)
    end
    love.graphics.line(segments)
end

return drawFunctions