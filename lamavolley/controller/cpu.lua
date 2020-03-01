local Object = require("lib.classic")
local Lama = require("lamavolley.lama")

local CPUController = Object:extend()

local State = Object:extend()

function State:new(controller)
  self.controller = controller
  self.lama = self.controller.lama
  self.ball = self.lama.ball
end

function State:update(dt)
  -- virtual
end

function State:changeState(StateType)
  self.controller.state = StateType(self.controller)
end

local IdleState = State:extend()
local ReceiveBallState = State:extend()
local ServingFirstKickState = State:extend()
local ServingSecondKickState = State:extend()

function IdleState:update(dt)
  if self.lama:isServing() then
    self:changeState(ServingFirstKickState)
  elseif
    self.ball.velocity.z > 0 and
      ((self.ball.position.y > 0 and self.lama.position.y < 0 and self.ball.velocity.y < 0) or
        (self.ball.position.y < 0 and self.lama.position.y > 0 and self.ball.velocity.y > 0))
   then
    self:changeState(ReceiveBallState)
  end
end

function ServingFirstKickState:update(dt)
  self.delayStart = self.delayStart == nil and dt or self.delayStart + dt

  if self.delayStart > 0.5 then
    self.lama:kick()
    self:changeState(ServingSecondKickState)
  end
end

function ServingSecondKickState:update(dt)
  if self.ball.velocity.z < 0 and self.ball.position.z <= 4 then
    self.lama:kick()
    self:changeState(IdleState)
  end
end

function ReceiveBallState:update()
  if self.ball.velocity.z < 0 and self.ball.position.z < 2 then
    self.lama:deactivateMotion(Lama.Motion.Up)
    self.lama:deactivateMotion(Lama.Motion.Right)
    self.lama:deactivateMotion(Lama.Motion.Down)
    self.lama:deactivateMotion(Lama.Motion.Left)
    self:changeState(IdleState)
    return
  end

  if not self.ball.prediction then
    return
  end

  if self.lama.position.y > self.ball.prediction.y and math.abs(self.lama.position.y - self.ball.prediction.y) > 0.5 then
    self.lama:activateMotion(Lama.Motion.Right)
    self.lama:deactivateMotion(Lama.Motion.Left)
  elseif self.lama.position.y < self.ball.prediction.y and math.abs(self.lama.position.y - self.ball.prediction.y) > 0.5 then
    self.lama:deactivateMotion(Lama.Motion.Right)
    self.lama:activateMotion(Lama.Motion.Left)
  else
    self.lama:deactivateMotion(Lama.Motion.Right)
    self.lama:deactivateMotion(Lama.Motion.Left)
  end

  if self.lama.position.x > self.ball.prediction.x and math.abs(self.lama.position.x - self.ball.prediction.x) > 0.5 then
    self.lama:activateMotion(Lama.Motion.Down)
    self.lama:deactivateMotion(Lama.Motion.Up)
  elseif self.lama.position.x < self.ball.prediction.x and math.abs(self.lama.position.x - self.ball.prediction.x) > 0.5 then
    self.lama:deactivateMotion(Lama.Motion.Down)
    self.lama:activateMotion(Lama.Motion.Up)
  else
    self.lama:deactivateMotion(Lama.Motion.Down)
    self.lama:deactivateMotion(Lama.Motion.Up)
  end

  if
    math.abs(self.lama.position.y - self.ball.prediction.y) <= 0.5 and
      math.abs(self.lama.position.x - self.ball.prediction.x) <= 0.5 and
      self.ball.position.z <= 4
   then
    self.lama:kick()
    self:changeState(IdleState)
  end
end

function CPUController:new(lama)
  self.lama = lama
  self.state = IdleState(self)
end

function CPUController:update(dt)
  self.state:update(dt)
end

function CPUController:keypressed()
  -- nothing to do here
end

function CPUController:keyreleased()
  -- nothing to do here
end

return CPUController
