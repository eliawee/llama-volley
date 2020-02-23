local GameScreen = require("lamavolley.screen.game")

local screen = GameScreen()

function love.load()
  love.window.setMode(1408, 1024)
end

function love.update(dt)
  screen:update(dt)
end

function love.draw()
  screen:draw()
end

function love.keypressed(key, unicode)
  screen:keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
  screen:keyreleased(key, unicode)
end
