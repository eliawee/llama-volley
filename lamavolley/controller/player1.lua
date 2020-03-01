local Object = require("lib.classic")
local Lama = require("lamavolley.lama")

local Player1Controller = Object:extend()

local WASD = {"z", "q", "s", "d"}

function Player1Controller:new(lama)
  self.lama = lama
end

function Player1Controller:update(dt)
  -- nothing to do here
end

function Player1Controller:keypressed(key)
  if key == "space" then
    self.lama:kick()
  end

  if key == WASD[1] then
    self.lama:activateMotion(Lama.Motion.Up)
  end

  if key == WASD[4] then
    self.lama:activateMotion(Lama.Motion.Right)
  end

  if key == WASD[3] then
    self.lama:activateMotion(Lama.Motion.Down)
  end

  if key == WASD[2] then
    self.lama:activateMotion(Lama.Motion.Left)
  end
end

function Player1Controller:keyreleased(key, unicode)
  if key == WASD[1] then
    self.lama:deactivateMotion(Lama.Motion.Up)
  end

  if key == WASD[4] then
    self.lama:deactivateMotion(Lama.Motion.Right)
  end

  if key == WASD[3] then
    self.lama:deactivateMotion(Lama.Motion.Down)
  end

  if key == WASD[2] then
    self.lama:deactivateMotion(Lama.Motion.Left)
  end
end

return Player1Controller
