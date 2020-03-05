local input = require("lamavolley.input")
local Court = require("lamavolley.court")
local Screen = require("lamavolley.screen")

local ModeScreen = Screen:extend()

local backgroundImage = love.graphics.newImage("assets/images/lama-playerchoicescreen.png")
local highlightImage = love.graphics.newImage("assets/images/lama-playerchoicescreen-highlight.png")

ModeScreen.Mode = {
  PlayerPlayer = 1,
  PlayerCPU = 2,
  CPUPLayer = 3
}

function ModeScreen:new()
  self.options = {
    {
      mode = ModeScreen.Mode.PlayerPlayer,
      highlightOffset = 320
    },
    {
      mode = ModeScreen.Mode.PlayerCPU,
      highlightOffset = 520
    },
    {
      mode = ModeScreen.Mode.CPUPlayer,
      highlightOffset = 720
    }
  }

  self.activeOptionIndex = 1
end

function ModeScreen:update()
  if input.anyPressed("action") then
    self:navigate("game", self.options[self.activeOptionIndex].mode)
  end

  if input.anyPressed("down") then
    self.activeOptionIndex = self.activeOptionIndex < table.getn(self.options) and self.activeOptionIndex + 1 or 1
  end

  if input.anyPressed("up") then
    self.activeOptionIndex = self.activeOptionIndex > 1 and self.activeOptionIndex - 1 or table.getn(self.options)
  end
end

function ModeScreen:draw()
  love.graphics.draw(backgroundImage, 0, 0)
  love.graphics.draw(highlightImage, 0, self.options[self.activeOptionIndex].highlightOffset)
end

return ModeScreen
