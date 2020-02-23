local Ball = require("lamavolley.ball")
local Court = require("lamavolley.court")
local Lama = require("lamavolley.lama")

local WASD = {"z", "q", "s", "d"}
local backgroundImage = love.graphics.newImage("assets/images/bg.png")

local court = Court({x = 100, y = 200}, {x = 192, y = 320})
local ball = Ball(court, 0, -50, 10)

local lamas = {
  Lama(court, ball, 0, 50, Lama.Direction.Right, Lama.Color.Red),
  Lama(court, ball, 0, -50, Lama.Direction.Left, Lama.Color.Blue)
}

function love.load()
  print(backgroundImage:getDimensions())
  love.window.setMode(backgroundImage:getDimensions())
end

function love.update(dt)
  for index, lama in pairs(lamas) do
    lama:update(dt)
  end

  ball:update(dt)
end

function love.draw()
  love.graphics.draw(backgroundImage, 0, 0)

  court:draw()
  ball:drawShadow()

  for index, lama in pairs(lamas) do
    lama:draw()
    --
  end

  ball:draw()
end

function love.keypressed(key, unicode)
  if key == "escape" then
    ball.position.x = 0
    ball.position.y = -50
    ball.position.z = 10
  end

  if key == "space" then
    lamas[1]:headKick()
  end

  if key == "return" then
    lamas[2]:headKick()
  end

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

  if key == WASD[1] then
    lamas[1]:activateMotion(Lama.Motion.Up)
  end

  if key == WASD[4] then
    lamas[1]:activateMotion(Lama.Motion.Right)
  end

  if key == WASD[3] then
    lamas[1]:activateMotion(Lama.Motion.Down)
  end

  if key == WASD[2] then
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

  if key == WASD[1] then
    lamas[1]:deactivateMotion(Lama.Motion.Up)
  end

  if key == WASD[4] then
    lamas[1]:deactivateMotion(Lama.Motion.Right)
  end

  if key == WASD[3] then
    lamas[1]:deactivateMotion(Lama.Motion.Down)
  end

  if key == WASD[2] then
    lamas[1]:deactivateMotion(Lama.Motion.Left)
  end
end
