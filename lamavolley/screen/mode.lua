local input = require("lamavolley.input")
local Court = require("lamavolley.court")
local Screen = require("lamavolley.screen")

local ModeScreen = Screen:extend()

local backgroundImage = love.graphics.newImage("assets/images/bg.png")

function ModeScreen:new()
  self.court = Court({x = 100, y = 200}, {x = 192, y = 384}, 6)
end

function ModeScreen:update()
  if input.anyActionPressed() then
    self:navigate("game")
  end
end

function ModeScreen:draw()
  love.graphics.draw(backgroundImage, 0, 0)
  self.court:draw()
  -- love.graphics.setFont(font)
  -- love.graphics.print("PRESS RETURN TO BEGIN", 160, 680)
  -- love.graphics.setFont(fontSmall)
  -- love.graphics.setColor(0, 0, 0, 0.4)
  -- love.graphics.print("LLAMARTIST: Estelle Martinez", 300, 850)
  -- love.graphics.print("ALPACODER: David Corticchiato", 300, 880)
  -- love.graphics.setFont(fontSmaller)
  -- love.graphics.print(
  --   "Music: 06-06-19 synthwave by Spring (https://opengameart.org/content/06-06-19-synthwave)",
  --   10,
  --   980
  -- )
  -- love.graphics.print("Sounds: Applause by Blender Foundation (https://opengameart.org/content/applause)", 10, 995)
  -- love.graphics.setColor(1, 1, 1, 1)
end

return ModeScreen
