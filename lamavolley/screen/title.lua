local Screen = require("lamavolley.screen")

local TitleScreen = Screen:extend()

local backgroundImage = love.graphics.newImage("assets/images/lama-title.png")

function TitleScreen:draw()
  love.graphics.draw(backgroundImage, 0, 0)
end

return TitleScreen
