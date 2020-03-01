local Object = require("lib.classic")
local Lama = require("lamavolley.lama")

local Player2Controller = Object:extend()

function Player2Controller:new(lama)
  self.lama = lama
end

function Player2Controller:keypressed(key)
  if key == "return" or key == "kpenter" then
    self.lama:kick()
  end

  if key == "up" then
    self.lama:activateMotion(Lama.Motion.Up)
  end

  if key == "right" then
    self.lama:activateMotion(Lama.Motion.Right)
  end

  if key == "down" then
    self.lama:activateMotion(Lama.Motion.Down)
  end

  if key == "left" then
    self.lama:activateMotion(Lama.Motion.Left)
  end
end

function Player2Controller:keyreleased(key, unicode)
  if key == "up" then
    self.lama:deactivateMotion(Lama.Motion.Up)
  end

  if key == "right" then
    self.lama:deactivateMotion(Lama.Motion.Right)
  end

  if key == "down" then
    self.lama:deactivateMotion(Lama.Motion.Down)
  end

  if key == "left" then
    self.lama:deactivateMotion(Lama.Motion.Left)
  end
end

return Player2Controller
