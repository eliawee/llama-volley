local baton = require("lib.baton")
local Object = require("lib.classic")
local Lama = require("lamavolley.lama")

local Player2Controller = Object:extend()

local input =
  baton.new(
  {
    controls = {
      left = {"key:left", "axis:leftx-"},
      right = {"key:right", "axis:leftx+"},
      up = {"key:up", "axis:lefty-"},
      down = {"key:down", "axis:lefty+"},
      action = {"key:return", "key:kpenter", "button:a"}
    },
    joystick = love.joystick.getJoysticks()[2]
  }
)

function Player2Controller:new(lama)
  self.lama = lama
end

function Player2Controller:update(dt)
  input:update()

  if input:pressed("action") then
    self.lama:kick()
  end

  if input:pressed("up") then
    self.lama:activateMotion(Lama.Motion.Up)
  end

  if input:pressed("right") then
    self.lama:activateMotion(Lama.Motion.Right)
  end

  if input:pressed("down") then
    self.lama:activateMotion(Lama.Motion.Down)
  end

  if input:pressed("left") then
    self.lama:activateMotion(Lama.Motion.Left)
  end

  if input:released("up") then
    self.lama:deactivateMotion(Lama.Motion.Up)
  end

  if input:released("right") then
    self.lama:deactivateMotion(Lama.Motion.Right)
  end

  if input:released("down") then
    self.lama:deactivateMotion(Lama.Motion.Down)
  end

  if input:released("left") then
    self.lama:deactivateMotion(Lama.Motion.Left)
  end
end

function Player2Controller:keypressed(key)
end

function Player2Controller:keyreleased(key, unicode)
end

return Player2Controller
