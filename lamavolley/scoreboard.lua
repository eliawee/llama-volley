local Object = require("lib.classic")

local ScoreBoard = Object:extend()

local font = love.graphics.newFont("assets/fonts/emulogic.ttf", 40)

function ScoreBoard:new()
  self.player1Score = 0
  self.player1ScoreText = love.graphics.newText(font, "0")
  self.player2Score = 0
  self.player2ScoreText = love.graphics.newText(font, "0")
end

function ScoreBoard:incrementScore(player)
  if player == 1 then
    self.player1Score = self.player1Score + 1
    self.player1ScoreText:set(tostring(self.player1Score))
  else
    self.player2Score = self.player2Score + 1
    self.player2ScoreText:set(tostring(self.player2Score))
  end
end

function ScoreBoard:draw()
  love.graphics.setColor(217 / 255, 87 / 255, 99 / 255, 1)
  love.graphics.draw(self.player1ScoreText, 675 - self.player1ScoreText:getWidth(), 168)
  love.graphics.setColor(99 / 255, 155 / 255, 255 / 255, 1)
  love.graphics.draw(self.player2ScoreText, 725, 168)
  love.graphics.setColor(1, 1, 1, 1)
end

return ScoreBoard
