local Object = require("lib.classic")
local Ball = require("lamavolley.ball")
local Court = require("lamavolley.court")
local Lama = require("lamavolley.lama")
local ScoreBoard = require("lamavolley.scoreboard")

local GameScreen = Object:extend()

local WASD = {"w", "a", "s", "d"}
local backgroundImage = love.graphics.newImage("assets/images/bg.png")

function GameScreen:new()
  self.court = Court({x = 100, y = 200}, {x = 192, y = 320}, 6)
  self.ball = Ball(self.court, 0, 0, 100)
  self.scoreBoard = ScoreBoard(self.court)
  self.lamas = {
    Lama(self.court, self.ball, 0, 50, Lama.Direction.Right, Lama.Color.Red),
    Lama(self.court, self.ball, 0, -50, Lama.Direction.Left, Lama.Color.Blue)
  }

  self.lastServing = 1

  self.ball:onFall(
    function()
      self:onBallFall()
    end
  )

  self.ball:onStop(
    function()
      self:onBallStop()
    end
  )

  self.lamas[1]:serve()
end

function GameScreen:onBallFall()
  if self.ball.lastKickingLama and self.ball.lastKickingLama == self.lamas[1] then
    if
      self.ball.position.x <= self.court.dimensions.x / 2 and self.ball.position.x >= -self.court.dimensions.x / 2 and
        self.ball.position.y < 0 and
        self.ball.position.y >= -self.court.dimensions.y / 2
     then
      self.scoreBoard:incrementScore(1)
    else
      self.scoreBoard:incrementScore(2)
    end
  elseif self.ball.lastKickingLama and self.ball.lastKickingLama == self.lamas[2] then
    if
      self.ball.position.x <= self.court.dimensions.x / 2 and self.ball.position.x >= -self.court.dimensions.x / 2 and
        self.ball.position.y > 0 and
        self.ball.position.y <= self.court.dimensions.y / 2
     then
      self.scoreBoard:incrementScore(2)
    else
      self.scoreBoard:incrementScore(1)
    end
  end
end

function GameScreen:onBallStop()
  self.lamas[1].position.x = 0
  self.lamas[1].position.y = 50
  self.lamas[2].position.x = 0
  self.lamas[2].position.y = -50
  self.ball.velocity.x = 0
  self.ball.velocity.y = 0
  self.ball.velocity.z = 0
  self.ball.prediction = nil
  self.ball.lastKickingLama = nil
  self.lastServing = self.lastServing == 1 and 2 or 1
  self.lamas[self.lastServing]:serve()
end

function GameScreen:update(dt)
  for index, lama in pairs(self.lamas) do
    lama:update(dt)
  end

  self.ball:update(dt)
end

function GameScreen:draw()
  love.graphics.draw(backgroundImage, 0, 0)

  self.court:draw()

  for index, lama in pairs(self.lamas) do
    lama:drawShadow()
  end

  self.scoreBoard:draw()
  self.ball:drawShadow()
  self.ball:drawPrediction()

  if self.ball.position.y > 0 then
    self.lamas[2]:draw()

    if self.ball.position.x > self.lamas[1].position.x then
      self.ball:draw()
      self.lamas[1]:draw()
    else
      self.lamas[1]:draw()
      self.ball:draw()
    end
  else
    self.lamas[1]:draw()

    if self.ball.position.x > self.lamas[2].position.x then
      self.ball:draw()
      self.lamas[2]:draw()
    else
      self.lamas[2]:draw()
      self.ball:draw()
    end
  end
end

function GameScreen:keypressed(key)
  if key == "space" then
    self.lamas[1]:kick()
  end

  if key == "return" or key == "kpenter" then
    self.lamas[2]:kick()
  end

  if key == "up" then
    self.lamas[2]:activateMotion(Lama.Motion.Up)
  end

  if key == "right" then
    self.lamas[2]:activateMotion(Lama.Motion.Right)
  end

  if key == "down" then
    self.lamas[2]:activateMotion(Lama.Motion.Down)
  end

  if key == "left" then
    self.lamas[2]:activateMotion(Lama.Motion.Left)
  end

  if key == WASD[1] then
    self.lamas[1]:activateMotion(Lama.Motion.Up)
  end

  if key == WASD[4] then
    self.lamas[1]:activateMotion(Lama.Motion.Right)
  end

  if key == WASD[3] then
    self.lamas[1]:activateMotion(Lama.Motion.Down)
  end

  if key == WASD[2] then
    self.lamas[1]:activateMotion(Lama.Motion.Left)
  end
end

function GameScreen:keyreleased(key, unicode)
  if key == "up" then
    self.lamas[2]:deactivateMotion(Lama.Motion.Up)
  end

  if key == "right" then
    self.lamas[2]:deactivateMotion(Lama.Motion.Right)
  end

  if key == "down" then
    self.lamas[2]:deactivateMotion(Lama.Motion.Down)
  end

  if key == "left" then
    self.lamas[2]:deactivateMotion(Lama.Motion.Left)
  end

  if key == WASD[1] then
    self.lamas[1]:deactivateMotion(Lama.Motion.Up)
  end

  if key == WASD[4] then
    self.lamas[1]:deactivateMotion(Lama.Motion.Right)
  end

  if key == WASD[3] then
    self.lamas[1]:deactivateMotion(Lama.Motion.Down)
  end

  if key == WASD[2] then
    self.lamas[1]:deactivateMotion(Lama.Motion.Left)
  end
end

return GameScreen
