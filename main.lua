local input = require("lamavolley.input")

local maxWidth, maxHeight = love.window.getDesktopDimensions()
local needScale = maxWidth < 1408 or maxHeight < 1024

local windowWidth = needScale and 1408 / 2 or 1408
local windowHeight = needScale and 1024 / 2 or 1024

love.window.setMode(windowWidth, windowHeight)
love.window.setTitle("Pro League Llama V'Ball Championship")

local state = {
  loaded = false
}

function love.load()
  local Screen = require("lamavolley.screen")
  local GameScreen = require("lamavolley.screen.game")
  local ModeScreen = require("lamavolley.screen.mode")
  local TitleScreen = require("lamavolley.screen.title")
  local screens = {
    game = GameScreen,
    mode = ModeScreen,
    title = TitleScreen
  }

  state.canvas = love.graphics.newCanvas(1408, 1024)
  state.music = love.audio.newSource("assets/sounds/synthwave.ogg", "static")
  state.screen = TitleScreen()

  Screen.onNavigate(
    function(screenName, parameter)
      local screenConstructor = screens[screenName]

      if screenConstructor then
        state.screen = screenConstructor(parameter)
      end
    end
  )

  state.music:setLooping(true)
  state.music:play()
end

function love.update(dt)
  for index, player in pairs(input.players) do
    player:update()
  end

  state.screen:update(dt)
end

function love.draw()
  if needScale then
    love.graphics.setCanvas(state.canvas)
    love.graphics.clear()
  end

  state.screen:draw()

  if needScale then
    love.graphics.setCanvas()
    love.graphics.draw(state.canvas, 0, 0, 0, 0.5, 0.5)
  end
end
