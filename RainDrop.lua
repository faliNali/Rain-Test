local RainDrop = {}
RainDrop.__index = RainDrop
local function getRandomColor()
    local colors = {}
    for _=1, 3 do
        table.insert(colors, math.random(150, 255)/255)
    end
    return colors
   -- return {math.random(), math.random(), math.random()}
end
function RainDrop.new(x, y, yPopPosition)
    local self = setmetatable({}, RainDrop)

    self.x, self.y = x, y
    self.speed = 240
    self.yPopPosition = yPopPosition
    self.popped = false
    self.durationPopped = 0
    self.angle = math.pi*0.25 + (math.random()-0.5)*0.25
    self.angleVelocity = (math.random()-0.25)*0.25
    self.color = getRandomColor()

    return self
end

function RainDrop:update(dt)
    if self.popped then
        self.durationPopped = self.durationPopped + dt
    else
        --self.x, self.y = self.x + self.speed * dt, self.y + self.speed * dt
        self.x = self.x + math.cos(self.angle) * self.speed * dt
        self.y = self.y + math.sin(self.angle) * self.speed * dt
        self.angle = self.angle + self.angleVelocity * dt
    end

    if self.y > self.yPopPosition then self.popped = true end
end

function RainDrop:getPosition() return self.x, self.y end
function RainDrop:getX() return self.x end
function RainDrop:getY() return self.y end

return RainDrop