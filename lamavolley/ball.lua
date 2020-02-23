local Object = require("lib.classic")
local Position = require("lamavolley.position")
local Lama = require("lamavolley.lama")

local image = love.graphics.newImage("assets/images/lama-ball.png")
local shadowImage = love.graphics.newImage("assets/images/lama-ball-shadow.png")
local targetImage = love.graphics.newImage("assets/images/lama-ball-target.png")

local Ball = Object:extend()

Ball.gravity = 50
Ball.maxVelocity = 200
Ball.Width = 32
Ball.Height = 32

function Ball:new(court, x, y, z)
  self.court = court
  self.position = Position(x, y, z)
  self.velocity = Position(0, 0, 0)
  self.servingLama = nil
  self.playable = true
end

function Ball:onStop(listener)
  self.listener = listener
end

function Ball:showPrediction()
  self.prediction = self:predictFallPosition()
end

function Ball:predictFallPosition()
  local position = self.position:clone()
  local velocity = self.velocity:clone()

  local dt = 0.16

  while position.z > 0.5 do
    velocity.z = velocity.z - Ball.gravity * dt

    if math.abs(velocity.z) >= Ball.maxVelocity then
      velocity.z = (velocity.z / math.abs(velocity.z)) * Ball.maxVelocity
    end

    position.x = position.x + velocity.x * dt
    position.y = position.y + velocity.y * dt
    position.z = position.z + velocity.z * dt
  end

  return position
end

function Ball:update(dt)
  if self.servingLama then
    self.position = self.servingLama:getServingBallPosition()
    return
  end

  self.velocity.z = self.velocity.z - Ball.gravity * dt

  if math.abs(self.velocity.z) >= Ball.maxVelocity then
    self.velocity.z = (self.velocity.z / math.abs(self.velocity.z)) * Ball.maxVelocity
  end

  self.position.z = self.position.z + self.velocity.z * dt

  if self.position.z <= 0.5 then
    self.playable = false

    if self.velocity.z < 0 then
      self.velocity.z = -self.velocity.z / 2
      self.velocity.x = self.velocity.x / 2
      self.velocity.y = self.velocity.y / 2
    end

    self.position.z = 0.5

    if math.abs(self.velocity.z) < 1 and self.listener then
      self.listener()
    end
  else
    self.position.x = self.position.x + self.velocity.x * dt
    self.position.y = self.position.y + self.velocity.y * dt
  end
end

function Ball:draw()
  local center = self.court:getScreenPosition(self.position, true)

  love.graphics.draw(image, center.x - Ball.Width / 2, center.y - Ball.Height / 2)
end

function Ball:drawShadow()
  local center = self.court:getScreenPosition(self.position, false)

  love.graphics.draw(shadowImage, center.x - Ball.Width / 2, center.y - Ball.Height / 2)
end

function Ball:drawPrediction()
  if self.prediction then
    local center = self.court:getScreenPosition(self.prediction, false)

    love.graphics.draw(targetImage, center.x - 32, center.y - 24)
  end
end

return Ball
