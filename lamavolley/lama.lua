local Object = require("lib.classic")
local Position = require("lamavolley.position")

local images = {
  red = {
    motion = love.graphics.newImage("assets/images/lama-red.png"),
    buttKick = love.graphics.newImage("assets/images/lama-red-buttkick.png"),
    headKick = love.graphics.newImage("assets/images/lama-red-headkick.png")
  },
  blue = {
    motion = love.graphics.newImage("assets/images/lama-blue.png"),
    buttKick = love.graphics.newImage("assets/images/lama-blue-buttkick.png"),
    headKick = love.graphics.newImage("assets/images/lama-blue-headkick.png")
  },
  shadow = love.graphics.newImage("assets/images/lama-shadow.png")
}

local quads = {
  buttKick = love.graphics.newQuad(0, 0, 128, 128, images.red.buttKick:getDimensions()),
  headKick = love.graphics.newQuad(0, 0, 128, 128, images.red.headKick:getDimensions()),
  stand = love.graphics.newQuad(0, 0, 128, 128, images.red.motion:getDimensions()),
  run = {
    love.graphics.newQuad(0, 0, 128, 128, images.red.motion:getDimensions()),
    love.graphics.newQuad(128, 0, 128, 128, images.red.motion:getDimensions()),
    love.graphics.newQuad(256, 0, 128, 128, images.red.motion:getDimensions())
  }
}

local Lama = Object:extend()
local count = 0

Lama.Velocity = 50
Lama.Width = 128
Lama.Height = 128

Lama.Direction = {
  Left = 1,
  Right = 2
}

Lama.Motion = {
  Up = 1,
  Right = 2,
  Down = 3,
  Left = 4
}

Lama.Color = {
  Red = 1,
  Blue = 2
}

function Lama:new(court, ball, x, y, direction, color)
  self.court = court
  self.ball = ball
  self.direction = direction
  self.motions = {}
  self.position = Position(x, y, 0)
  self.animation = {
    duration = 0.2,
    cursor = 0,
    frame = 1,
    active = false
  }
  self.headKickState = {
    active = false,
    duration = 0.2,
    cursor = 0
  }
  self.buttKickState = {
    active = false,
    duration = 0.2,
    cursor = 0
  }
  self.images = color == Lama.Color.Blue and images.blue or images.red
  count = count + 1
  self.id = count
end

function Lama:canTranslateY(distance)
  return not (self.direction == Lama.Direction.Right and self.position.y + distance - 10 <= 0) and
    not (self.direction == Lama.Direction.Right and self.position.y + distance - 10 >= self.court.dimensions.y / 2) and
    not (self.direction == Lama.Direction.Left and self.position.y + distance + 10 >= 0) and
    not (self.direction == Lama.Direction.Left and self.position.y + distance + 10 <= -self.court.dimensions.y / 2)
end

function Lama:canTranslateX(distance)
  return not (math.abs(self.position.x + distance) > self.court.dimensions.x / 2)
end

function Lama:update(dt)
  local directionCorrection = self.direction == Lama.Direction.Right and 1 or -1

  if self.motions[Lama.Motion.Up] == true and self:canTranslateX(dt * Lama.Velocity) then
    self.position:translate(dt * Lama.Velocity, 0)
  end

  if self.motions[Lama.Motion.Right] == true and self:canTranslateY(-dt * Lama.Velocity) then
    self.position:translate(0, -dt * Lama.Velocity)
  end

  if self.motions[Lama.Motion.Down] == true and self:canTranslateX(-dt * Lama.Velocity) then
    self.position:translate(-dt * Lama.Velocity, 0)
  end

  if self.motions[Lama.Motion.Left] == true and self:canTranslateY(dt * Lama.Velocity) then
    self.position:translate(0, dt * Lama.Velocity)
  end

  if self.headKickState.active then
    self.headKickState.cursor = self.headKickState.cursor + dt

    if self.headKickState.cursor >= self.headKickState.duration then
      self.headKickState.active = false
    end
  end

  if self.buttKickState.active then
    self.buttKickState.cursor = self.buttKickState.cursor + dt

    if self.buttKickState.cursor >= self.buttKickState.duration then
      self.buttKickState.active = false
    end
  end

  if self.animation.active then
    self.animation.cursor = self.animation.cursor + dt

    if self.animation.cursor >= self.animation.duration then
      self.animation.frame = self.animation.frame + 1
      self.animation.cursor = 0

      if self.animation.frame > 3 then
        self.animation.frame = 1
      end
    end
  end

  if self:isServing() and self.buttKickState.active then
    self.ball.velocity.z = 30
    self.ball.servingLama = nil
  end

  if
    self.headKickState.active and (not self.lastKick or love.timer.getTime() - self.lastKick > 0.5) and
      self.ball.playable and
      self.ball.position.z <= 4 and
      self.ball.position.z > 2 and
      math.abs(self.ball.position.x - self.position.x) < 10 and
      math.abs(self.ball.position.y - (self.position.y + 3)) < 20
   then
    local minBonus = 0.2
    local maxBonus = 1
    local bonusK = (4 * minBonus - 2) / (4 - 2)
    local bonusAlpha = (1 - bonusK) / 4
    local bonus = bonusAlpha * self.ball.position.z + bonusK

    if bonus < minBonus then
      bonus = minBonus
    elseif bonus > maxBonus then
      bonus = maxBonus
    end

    self.ball.velocity.z = 30 * bonus
    self.ball.velocity.x = 4 * (self.ball.position.x - self.position.x)
    self.ball.velocity.y = (self.direction == Lama.Direction.Left and 100 or -100)
    self.lastKick = love.timer.getTime()

    self.ball:showPrediction()
  end
end

function Lama:getServingBallPosition()
  return self.position:clone():translate(
    0,
    self.direction == Lama.Direction.Left and 7 or -7,
    self.animation.frame == 1 and 2 or 2.2
  )
end

function Lama:headKick()
  if not self.headKickState.active then
    self.headKickState.active = true
    self.headKickState.cursor = 0
  end
end

function Lama:buttKick()
  if self:isServing() and not self.buttKickState.active then
    self.buttKickState.active = true
    self.buttKickState.cursor = 0
  end
end

function Lama:kick()
  if self:isServing() then
    self:buttKick()
  else
    self:headKick()
  end
end

function Lama:resetRunAnimation()
  self.animation.active = true
  self.animation.cursor = 0
  self.animation.frame = 1
end

function Lama:stopRunAnimation()
  self.animation.active = false
end

function Lama:isInMotion()
  return self.motions[Lama.Motion.Left] or self.motions[Lama.Motion.Right] or self.motions[Lama.Motion.Up] or
    self.motions[Lama.Motion.Down]
end

function Lama:activateMotion(motion)
  if not self:isInMotion() then
    self:resetRunAnimation()
  end

  self.motions[motion] = true
end

function Lama:serve()
  self.ball.servingLama = self
  self.ball.playable = true
end

function Lama:deactivateMotion(motion)
  self.motions[motion] = false

  if not self:isInMotion() then
    self:stopRunAnimation()
  end
end

function Lama:drawShadow()
  local center = self.court:getScreenPosition(self.position, false)

  love.graphics.draw(images.shadow, center.x - 36, center.y - 15)
end

function Lama:isServing()
  return self.ball.servingLama and self.ball.servingLama.id == self.id
end

function Lama:getImageToDraw()
  if self.buttKickState.active then
    return self.images.buttKick
  elseif self.headKickState.active then
    return self.images.headKick
  else
    return self.images.motion
  end
end

function Lama:getQuadToDraw()
  if self.buttKickState.active then
    return quads.buttKick
  elseif self.headKickState.active then
    return quads.headKick
  else
    return self.animation.active and quads.run[self.animation.frame] or quads.stand
  end
end

function Lama:draw()
  local center = self.court:getScreenPosition(self.position, true)
  local needDirectionCorrection =
    (self.direction == Lama.Direction.Left and not (self:isServing() and not self.buttKickState.active)) or
    (self.direction == Lama.Direction.Right and (self:isServing() and not self.buttKickState.active))

  love.graphics.draw(
    self:getImageToDraw(),
    self:getQuadToDraw(),
    center.x - Lama.Width / 2 + ((needDirectionCorrection and 1 or 0) * Lama.Width),
    center.y - Lama.Height,
    0,
    needDirectionCorrection and -1 or 1,
    1
  )
end

return Lama
