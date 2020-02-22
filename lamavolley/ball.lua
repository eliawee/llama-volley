local Object = require("lib.classic")
local Position = require("lamavolley.position")

local image = love.graphics.newImage("assets/images/lama-ball.png")
local shadowImage = love.graphics.newImage("assets/images/lama-ball-shadow.png")

local Ball = Object:extend()

Ball.gravity = 100
Ball.maxVelocity = 200

function Ball:new(court, x, y, z)
  self.court = court
  self.position = Position(x, y, z)
  self.velocity = {x = 0, y = 0, z = 0}
end

function Ball:update(dt)
  self.velocity.z = self.velocity.z - Ball.gravity * dt

  if math.abs(self.velocity.z) >= Ball.maxVelocity then
    self.velocity.z = (self.velocity.z / math.abs(self.velocity.z)) * Ball.maxVelocity
  end

  self.position.x = self.position.x + self.velocity.x * dt
  self.position.y = self.position.y + self.velocity.y * dt
  self.position.z = self.position.z + self.velocity.z * dt

  if self.position.z <= 0 then
    self.position.z = 0
    self.velocity.x = 0
  end
end

function Ball:draw()
  local center = self.court:getScreenPosition(self.position, true)

  love.graphics.draw(image, center.x - 16, center.y - 16)
end

function Ball:drawShadow()
  local center = self.court:getScreenPosition(self.position, false)

  love.graphics.draw(shadowImage, center.x - 16, center.y - 16)
end

return Ball
