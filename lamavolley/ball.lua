local Object = require("lib.classic")
local Position = require("lamavolley.position")

local image = love.graphics.newImage("assets/images/lama-ball.png")

local Ball = Object:extend()

function Ball:new(court, x, y, z)
  self.court = court
  self.position = Position(x, y, z)
end

function Ball:update(dt)
end

function Ball:draw()
  local center = self.court:getScreenPosition(self.position)

  print(center.x, center.y)

  love.graphics.draw(image, center.x - 16, center.y - 16)
end

return Ball
