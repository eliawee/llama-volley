local Screen = require("lamavolley.screen")

local TitleScreen = Screen:extend()

local backgroundImage = love.graphics.newImage("assets/images/lama-title.png")
local font = love.graphics.newFont("assets/fonts/emulogic.ttf", 30)
local fontSmall = love.graphics.newFont("assets/fonts/emulogic.ttf", 20)
local fontSmaller = love.graphics.newFont("assets/fonts/emulogic.ttf", 10)

function TitleScreen:draw()
  love.graphics.draw(backgroundImage, 0, 0)
  love.graphics.setFont(font)
  love.graphics.print("PRESS RETURN TO BEGIN", 160, 680)
  love.graphics.setFont(fontSmall)
  love.graphics.setColor(0, 0, 0, 0.4)
  love.graphics.print("LLAMARTIST: Estelle Martinez", 300, 850)
  love.graphics.print("ALPACODER: David Corticchiato", 300, 880)
  love.graphics.setFont(fontSmaller)
  love.graphics.print("Music: 06-06-19 synthwave by Spring (https://opengameart.org/content/06-06-19-synthwave)", 10, 980)
  love.graphics.print("Sounds: Applause by Blender Foundation (https://opengameart.org/content/applause)", 10, 995)
  love.graphics.setColor(1, 1, 1, 1)
end

function TitleScreen:keypressed(key)
  if key == "return" or key == "kpenter" then
    self:navigate("game")
  end
end

return TitleScreen
