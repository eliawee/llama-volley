local Object = require("lib.classic")
local Position = require("lamavolley.position")
local Lama = require("lamavolley.lama")

local image = love.graphics.newImage("assets/images/lama-ball.png")
local shadowImage = love.graphics.newImage("assets/images/lama-ball-shadow.png")
local targetImage = love.graphics.newImage("assets/images/lama-ball-target.png")
local ballSounds = {
  love.audio.newSource("assets/sounds/qubodupPunch01.ogg", "static"),
  love.audio.newSource("assets/sounds/qubodupPunch02.ogg", "static"),
  love.audio.newSource("assets/sounds/qubodupPunch03.ogg", "static"),
  love.audio.newSource("assets/sounds/qubodupPunch04.ogg", "static")
}

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

function Ball:playSound()
  ballSounds[love.math.random(#ballSounds)]:play()
end

function Ball:onStop(listener)
  self.onStopListener = listener
end

function Ball:onFall(listener)
  self.onFallListener = listener
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
  else
    self.velocity.z = self.velocity.z - Ball.gravity * dt

    if math.abs(self.velocity.z) >= Ball.maxVelocity then
      self.velocity.z = (self.velocity.z / math.abs(self.velocity.z)) * Ball.maxVelocity
    end

    self.position.z = self.position.z + self.velocity.z * dt

    if self.position.z <= 0.5 then
      if self.playable and self.onFallListener then
        self.onFallListener()
      end

      self.playSound()

      self.playable = false

      if self.velocity.z < 0 then
        self.velocity.z = -self.velocity.z / 2
        self.velocity.x = self.velocity.x / 2
        self.velocity.y = self.velocity.y / 2
      end

      self.position.z = 0.5

      if math.abs(self.velocity.z) < 1 and self.onStopListener then
        self.onStopListener()
      end
    else
      local lastY = self.position.y
      self.position.x = self.position.x + self.velocity.x * dt
      self.position.y = self.position.y + self.velocity.y * dt

      if
        ((self.position.y < 0 and lastY >= 0) or (self.position.y > 0 and lastY <= 0)) and
          self.position.z < self.court.netHeight
       then
        local direction = -1 * (math.abs(self.velocity.y) / self.velocity.y)
        self.touchedNet = false
        self.position.y = lastY
        self.velocity.y = direction * 20
      end
    end
  end

  self.center = self.court:getScreenPosition(self.position, true)
  self.shadowCenter = self.court:getScreenPosition(self.position, false)

  local scale = self.position.z <= 4 and 1 or (self.position.z - 4) * 0.5 / 6 + 1
  local maxVelocityScale =
    math.abs(self.velocity.z) > math.abs(self.velocity.y) and math.abs(self.velocity.z) or math.abs(self.velocity.y)
  self.scaleX = (maxVelocityScale == 0 and 1 or ((math.abs(self.velocity.y) / maxVelocityScale) * 0.08 + 1)) * scale
  self.scaleY = (maxVelocityScale == 0 and 1 or ((math.abs(self.velocity.z) / maxVelocityScale) * 0.08 + 1)) * scale
end

function Ball:sameSideAs(lama)
  return (self.position.y > 0 and lama.position.y > 0) or (self.position.y < 0 and lama.position.y < 0)
end

function Ball:draw()
  if self.center then
    love.graphics.draw(
      image,
      self.center.x - Ball.Width * self.scaleX / 2,
      self.center.y - Ball.Height * self.scaleY / 2,
      0,
      self.scaleX,
      self.scaleY
    )
  end
end

function Ball:drawShadow()
  if self.shadowCenter then
    love.graphics.draw(shadowImage, self.shadowCenter.x - Ball.Width / 2, self.shadowCenter.y - Ball.Height / 2)
  end
end

function Ball:drawPrediction()
  if self.prediction then
    local center = self.court:getScreenPosition(self.prediction, false)

    love.graphics.draw(targetImage, center.x - 32, center.y - 24)
  end
end

return Ball
