local Object = require("lib.classic")
local image = love.graphics.newImage("assets/images/lama-ball.png")

local Ball = Object:extend()

function Ball:new(x, y)
  self.transform = love.math.newTransform(x, y)
end

function Ball:update(dt)
end

function Ball:draw()
  love.graphics.draw(image, self.transform)
end

return Ball
