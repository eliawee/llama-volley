local GameScreen = require("lamavolley.screen.game")
local TitleScreen = require("lamavolley.screen.title")

local screen = GameScreen()

local maxWidth = love.graphics.getWidth()
local maxHeight = love.graphics.getHeight()

local needScale = maxWidth < 1408 or maxHeight < 1024

local canvas = love.graphics.newCanvas(1408, 1024)

function love.load()
  love.window.setMode(needScale and 1408 / 2 or 1408, needScale and 1024 / 2 or 1024)
end

function love.update(dt)
  screen:update(dt)
end

function love.draw()
  if needScale then
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
  end

  screen:draw()

  if needScale then
    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, 0.5, 0.5)
  end
end

function love.keypressed(key, unicode)
  screen:keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
  screen:keyreleased(key, unicode)
end
