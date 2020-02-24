local Screen = require("lamavolley.screen")
local GameScreen = require("lamavolley.screen.game")
local TitleScreen = require("lamavolley.screen.title")
local SubSource = require("lamavolley.subsource")

local screen = TitleScreen()

local maxWidth, maxHeight = love.window.getDesktopDimensions()
local needScale = maxWidth < 1408 or maxHeight < 1024

local canvas = love.graphics.newCanvas(1408, 1024)
local music = love.audio.newSource("assets/sounds/synthwave.ogg", "static")

Screen.onNavigate(
  function(screenName)
    if screenName == "game" then
      screen = GameScreen()
    elseif screenName == "title" then
      screen = TitleScreen()
    end
  end
)

function love.load()
  love.window.setMode(needScale and 1408 / 2 or 1408, needScale and 1024 / 2 or 1024)
  love.window.setTitle("Pro League Llama V'Ball Championship")

  --SubSource(music, 5, 10):play()
  music:setLooping(true)
  music:play()
end

function love.update(dt)
  screen:update(dt)
  SubSource.updateAll()
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
