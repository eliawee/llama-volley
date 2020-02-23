local GameScreen = require("lamavolley.screen.game")
local TitleScreen = require("lamavolley.screen.title")

local screen = GameScreen()
local canvas = love.graphics.newCanvas(1408, 1024)

function love.load()
  love.window.setMode(1408 / 2, 1024 / 2)
end

function love.update(dt)
  screen:update(dt)
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  screen:draw()
  love.graphics.setCanvas()
  love.graphics.draw(canvas, 0, 0, 0, 0.5, 0.5)
end

function love.keypressed(key, unicode)
  screen:keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
  screen:keyreleased(key, unicode)
end
