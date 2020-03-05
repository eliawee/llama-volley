local input = require("lamavolley.input")

local maxWidth, maxHeight = love.window.getDesktopDimensions()
local needScale = maxWidth < 1408 or maxHeight < 1024

local windowWidth = needScale and 1408 / 2 or 1408
local windowHeight = needScale and 1024 / 2 or 1024

love.window.setMode(windowWidth, windowHeight)
love.window.setTitle("Pro League Llama V'Ball Championship")

local state = {
  firstUpdate = true,
  loadedCount = 0,
  loaded = false,
  loadables = {
    function(state)
      state.Screen = require("lamavolley.screen")
    end,
    function(state)
      state.GameScreen = require("lamavolley.screen.game")
    end,
    function(state)
      state.ModeScreen = require("lamavolley.screen.mode")
    end,
    function(state)
      state.TitleScreen = require("lamavolley.screen.title")
    end,
    function(state)
      state.canvas = love.graphics.newCanvas(1408, 1024)
    end,
    function(state)
      state.music = love.audio.newSource("assets/sounds/synthwave.ogg", "stream")
    end,
    function(state)
      state.screen = state.TitleScreen()

      local screens = {
        game = state.GameScreen,
        mode = state.ModeScreen,
        title = state.TitleScreen
      }

      state.Screen.onNavigate(
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
  }
}

function love.update(dt)
  if state.loaded then
    for index, player in pairs(input.players) do
      player:update()
    end

    state.screen:update(dt)
  elseif not state.firstUpdate then
    state.loadables[state.loadedCount + 1](state)
    state.loadedCount = state.loadedCount + 1

    if state.loadedCount == table.getn(state.loadables) then
      state.loaded = true
    end
  else
    state.firstUpdate = false
  end
end

function love.draw()
  if state.loaded then
    if needScale then
      love.graphics.setCanvas(state.canvas)
      love.graphics.clear()
    end

    state.screen:draw()

    if needScale then
      love.graphics.setCanvas()
      love.graphics.draw(state.canvas, 0, 0, 0, 0.5, 0.5)
    end
  else
    love.graphics.printf(
      "Loading: " .. tostring(math.ceil(state.loadedCount * 100 / table.getn(state.loadables))) .. "%",
      250,
      200,
      200,
      "center"
    )
  end
end
