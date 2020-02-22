local Ball = require("lamavolley.ball")
local Court = require("lamavolley.court")
local Lama = require("lamavolley.lama")

local lamas = {}
-- Lama(256, 384, Lama.Direction.Right),00
-- Lama(768, 384, Lama.Direction.Left)

local court = Court({x = 100, y = 200}, {x = 0, y = 0})
local ball = Ball(court, 50, -100)

local groundImage = love.graphics.newImage("assets/images/lama-ground.png")

function love.load()
  love.window.setMode(1024, 768)
end

function love.update(dt)
  for index, lama in pairs(lamas) do
    lama:update(dt)
  end

  ball:update(dt)
end

function love.draw()
  love.graphics.draw(groundImage, 0, 0)

  for index, lama in pairs(lamas) do
    lama:draw()
  end

  ball:draw()
end

function love.keypressed(key, unicode)
  if key == "up" then
    lamas[2]:activateMotion(Lama.Motion.Up)
  end

  if key == "right" then
    lamas[2]:activateMotion(Lama.Motion.Right)
  end

  if key == "down" then
    lamas[2]:activateMotion(Lama.Motion.Down)
  end

  if key == "left" then
    lamas[2]:activateMotion(Lama.Motion.Left)
  end

  if key == "w" then
    lamas[1]:activateMotion(Lama.Motion.Up)
  end

  if key == "d" then
    lamas[1]:activateMotion(Lama.Motion.Right)
  end

  if key == "s" then
    lamas[1]:activateMotion(Lama.Motion.Down)
  end

  if key == "a" then
    lamas[1]:activateMotion(Lama.Motion.Left)
  end
end

function love.keyreleased(key, unicode)
  if key == "up" then
    lamas[2]:deactivateMotion(Lama.Motion.Up)
  end

  if key == "right" then
    lamas[2]:deactivateMotion(Lama.Motion.Right)
  end

  if key == "down" then
    lamas[2]:deactivateMotion(Lama.Motion.Down)
  end

  if key == "left" then
    lamas[2]:deactivateMotion(Lama.Motion.Left)
  end

  if key == "w" then
    lamas[1]:deactivateMotion(Lama.Motion.Up)
  end

  if key == "d" then
    lamas[1]:deactivateMotion(Lama.Motion.Right)
  end

  if key == "s" then
    lamas[1]:deactivateMotion(Lama.Motion.Down)
  end

  if key == "a" then
    lamas[1]:deactivateMotion(Lama.Motion.Left)
  end
end
