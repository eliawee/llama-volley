local input = require("lamavolley.input")
local Ball = require("lamavolley.ball")
local Court = require("lamavolley.court")
local Lama = require("lamavolley.lama")
local PlayerController = require("lamavolley.controller.player")
local CPUController = require("lamavolley.controller.cpu")
local Screen = require("lamavolley.screen")
local ScoreBoard = require("lamavolley.scoreboard")
local ModeScreen = require("lamavolley.screen.mode")

local GameScreen = Screen:extend()

local backgroundImage = love.graphics.newImage("assets/images/bg.png")
local redWinnerImage = love.graphics.newImage("assets/images/lama-redwins.png")
local blueWinnerImage = love.graphics.newImage("assets/images/lama-bluewins.png")
local applauseSound = love.audio.newSource("assets/sounds/applause.wav", "static")

function GameScreen:new(mode)
  self.court = Court({x = 100, y = 200}, {x = 192, y = 384}, 5)
  self.ball = Ball(self.court, 0, 0, 100)
  self.scoreBoard = ScoreBoard(self.court)
  self.lamas = {
    Lama(self.court, self.ball, 0, 50, Lama.Direction.Right, Lama.Color.Red),
    Lama(self.court, self.ball, 0, -50, Lama.Direction.Left, Lama.Color.Blue)
  }

  self.controllers = {
    mode == ModeScreen.Mode.CPUPlayer and CPUController(self.lamas[1]) or
      PlayerController(self.lamas[1], input.players[1]),
    mode == ModeScreen.Mode.PlayerCPU and CPUController(self.lamas[2]) or
      PlayerController(self.lamas[2], input.players[2])
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

  self.scoreBoard:onLamaWin(
    function(winner)
      self.winner = winner
      applauseSound:play()
    end
  )

  self.winnerAnimation = {
    duration = 1,
    cursor = 0
  }

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
  if self.winner then
    if self.winnerAnimation.cursor < self.winnerAnimation.duration then
      self.winnerAnimation.cursor = self.winnerAnimation.cursor + dt
    elseif input.anyPressed("action") then
      self:navigate("title")
      applauseSound:stop()
    end

    return
  end

  if self.winner == nil then
    for index, controller in pairs(self.controllers) do
      controller:update(dt)
    end
  end

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

  love.graphics.setColor(1, 1, 1, self.winnerAnimation.cursor / self.winnerAnimation.duration)
  if self.winner == Lama.Color.Red then
    love.graphics.draw(redWinnerImage, 0, 0)
  elseif self.winner == Lama.Color.Blue then
    love.graphics.draw(blueWinnerImage, 0, 0)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return GameScreen
