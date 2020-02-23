local Object = require("lib.classic")
local Lama = require("lamavolley.lama")

local ScoreBoard = Object:extend()

local font = love.graphics.newFont("assets/fonts/emulogic.ttf", 40)

ScoreBoard.WinScore = 10

function ScoreBoard:new()
  self.playerRedScore = 0
  self.playerRedScoreText = love.graphics.newText(font, "0")
  self.playerBlueScore = 0
  self.playerBlueScoreText = love.graphics.newText(font, "0")
end

function ScoreBoard:onLamaWin(listener)
  self.onLamaWinListener = listener
end

function ScoreBoard:incrementScore(player)
  if player == 1 then
    self.playerRedScore = self.playerRedScore + 1
    self.playerRedScoreText:set(tostring(self.playerRedScore))
  else
    self.playerBlueScore = self.playerBlueScore + 1
    self.playerBlueScoreText:set(tostring(self.playerBlueScore))
  end

  if self.playerRedScore == ScoreBoard.WinScore and self.onLamaWinListener then
    self.onLamaWinListener(Lama.Color.Red)
  elseif self.playerBlueScore == ScoreBoard.WinScore and self.onLamaWinListener then
    self.onLamaWinListener(Lama.Color.Blue)
  end
end

function ScoreBoard:draw()
  love.graphics.setColor(217 / 255, 87 / 255, 99 / 255, 1)
  love.graphics.draw(self.playerRedScoreText, 675 - self.playerRedScoreText:getWidth(), 168)
  love.graphics.setColor(99 / 255, 155 / 255, 255 / 255, 1)
  love.graphics.draw(self.playerBlueScoreText, 725, 168)
  love.graphics.setColor(1, 1, 1, 1)
end

return ScoreBoard
