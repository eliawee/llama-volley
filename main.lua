local Screen = require("lamavolley.screen")
local GameScreen = require("lamavolley.screen.game")
local TitleScreen = require("lamavolley.screen.title")

local screen = TitleScreen()

local maxWidth, maxHeight = love.window.getDesktopDimensions()
local needScale = maxWidth < 1408 or maxHeight < 1024

local canvas = love.graphics.newCanvas(1408, 1024)

Screen.onNavigate(
  function(screenName)
    if screenName == "game" then
      screen = GameScreen()
    end
  end
)

function love.load()
  love.window.setMode(needScale and 1408 / 2 or 1408, needScale and 1024 / 2 or 1024)
  love.window.setTitle("Pro League Llama V'Ball Championship")
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
