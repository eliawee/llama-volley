local Object = require("lib.classic")

local image = love.graphics.newImage("assets/images/lama2-Sheet.png")

local quads = {
  stand = love.graphics.newQuad(0, 0, 128, 128, image:getDimensions()),
  run = {
    love.graphics.newQuad(0, 0, 128, 128, image:getDimensions()),
    love.graphics.newQuad(128, 0, 128, 128, image:getDimensions()),
    love.graphics.newQuad(256, 0, 128, 128, image:getDimensions())
  }
}

local Lama = Object:extend()

Lama.Velocity = 100

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

function Lama:new(x, y, direction)
  self.direction = direction
  self.motions = {}
  self.transform = love.math.newTransform(x, y, 0, self.direction == Lama.Direction.Right and 1 or -1, 1)
  self.animation = {
    duration = 0.2,
    cursor = 0,
    frame = 1,
    active = false
  }
end

function Lama:update(dt)
  local directionCorrection = self.direction == Lama.Direction.Right and 1 or -1

  if self.motions[Lama.Motion.Up] == true then
    self.transform:translate(0, -dt * Lama.Velocity)
  end

  if self.motions[Lama.Motion.Right] == true then
    self.transform:translate(directionCorrection * dt * Lama.Velocity, 0)
  end

  if self.motions[Lama.Motion.Down] == true then
    self.transform:translate(0, dt * Lama.Velocity)
  end

  if self.motions[Lama.Motion.Left] == true then
    self.transform:translate(-directionCorrection * dt * Lama.Velocity, 0)
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

function Lama:draw()
  local quad = self.animation.active and quads.run[self.animation.frame] or quads.stand

  love.graphics.draw(image, quad, self.transform)
end

return Lama
