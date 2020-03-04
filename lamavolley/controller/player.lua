local baton = require("lib.baton")
local Object = require("lib.classic")
local Lama = require("lamavolley.lama")

local PlayerController = Object:extend()

function PlayerController:new(lama, input)
  self.lama = lama
  self.input = input
end

function PlayerController:update(dt)
  if self.input:pressed("action") then
    self.lama:kick()
  end

  if self.input:pressed("up") then
    self.lama:activateMotion(Lama.Motion.Up)
  end

  if self.input:pressed("right") then
    self.lama:activateMotion(Lama.Motion.Right)
  end

  if self.input:pressed("down") then
    self.lama:activateMotion(Lama.Motion.Down)
  end

  if self.input:pressed("left") then
    self.lama:activateMotion(Lama.Motion.Left)
  end

  if self.input:released("up") then
    self.lama:deactivateMotion(Lama.Motion.Up)
  end

  if self.input:released("right") then
    self.lama:deactivateMotion(Lama.Motion.Right)
  end

  if self.input:released("down") then
    self.lama:deactivateMotion(Lama.Motion.Down)
  end

  if self.input:released("left") then
    self.lama:deactivateMotion(Lama.Motion.Left)
  end
end

return PlayerController
