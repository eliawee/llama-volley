local Object = require("lib.classic")
local Position = require("lamavolley.position")

local images = {
  red = {
    motion = love.graphics.newImage("assets/images/lama-red.png"),
    headKick = love.graphics.newImage("assets/images/lama-red-headkick.png")
  },
  blue = {
    motion = love.graphics.newImage("assets/images/lama-blue.png"),
    headKick = love.graphics.newImage("assets/images/lama-blue-headkick.png")
  },
  shadow = love.graphics.newImage("assets/images/lama-shadow.png")
}

local quads = {
  headKick = love.graphics.newQuad(0, 0, 128, 128, images.red.headKick:getDimensions()),
  stand = love.graphics.newQuad(0, 0, 128, 128, images.red.motion:getDimensions()),
  run = {
    love.graphics.newQuad(0, 0, 128, 128, images.red.motion:getDimensions()),
    love.graphics.newQuad(128, 0, 128, 128, images.red.motion:getDimensions()),
    love.graphics.newQuad(256, 0, 128, 128, images.red.motion:getDimensions())
  }
}

local Lama = Object:extend()

Lama.Velocity = 100
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
  self.images = color == Lama.Color.Blue and images.blue or images.red
end

function Lama:update(dt)
  local directionCorrection = self.direction == Lama.Direction.Right and 1 or -1

  if self.motions[Lama.Motion.Up] == true then
    self.position:translate(dt * Lama.Velocity, 0)
  end

  if self.motions[Lama.Motion.Right] == true then
    self.position:translate(0, -dt * Lama.Velocity)
  end

  if self.motions[Lama.Motion.Down] == true then
    self.position:translate(-dt * Lama.Velocity, 0)
  end

  if self.motions[Lama.Motion.Left] == true then
    self.position:translate(0, dt * Lama.Velocity)
  end

  if self.headKickState.active then
    self.headKickState.cursor = self.headKickState.cursor + dt

    if self.headKickState.cursor >= self.headKickState.duration then
      self.headKickState.active = false
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

  if
    self.headKickState.active and self.ball.position.z < 4 and self.ball.position.z > 2 and
      math.abs(self.ball.position.x - self.position.x) < 2 and
      math.abs(self.ball.position.y - (self.position.y + 3)) < 4
   then
    self.ball.velocity.z = 30
    self.ball.velocity.y = self.direction == Lama.Direction.Left and 100 or -100
  end
end

function Lama:headKick()
  if not self.headKickState.active then
    self.headKickState.active = true
    self.headKickState.cursor = 0
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

function Lama:draw()
  local quad = self.animation.active and quads.run[self.animation.frame] or quads.stand
  local center = self.court:getScreenPosition(self.position, true)

  love.graphics.draw(
    self.headKickState.active and self.images.headKick or self.images.motion,
    self.headKickState.active and quads.headKick or quad,
    center.x - Lama.Width / 2 + ((self.direction == Lama.Direction.Right and 0 or 1) * Lama.Width),
    center.y - Lama.Height,
    0,
    self.direction == Lama.Direction.Right and 1 or -1,
    1
  )
end

return Lama
