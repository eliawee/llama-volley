local Object = require("lib.classic")
local Position = require("lamavolley.position")

local Court = Object:extend()

Court.ScreenBounds = {
  UpLeft = {
    x = 128,
    y = 128
  },
  UpRight = {
    x = 896,
    y = 128
  },
  DownRight = {
    x = 960,
    y = 512
  },
  DownLeft = {
    x = 64,
    y = 512
  }
}

function Court:new(dimensions, screenOffset)
  self.dimensions = dimensions
  self.screenOffset = screenOffset
end

function Court:getLineBounds(position)
  local sideCoeff = position.x / self.dimensions.x + 0.5

  return {
    left = sideCoeff * (Court.ScreenBounds.UpLeft.x - Court.ScreenBounds.DownLeft.x) + Court.ScreenBounds.DownLeft.x,
    right = sideCoeff * (Court.ScreenBounds.UpRight.x - Court.ScreenBounds.DownRight.x) + Court.ScreenBounds.DownRight.x
  }
end

function Court:getScreenPosition(position)
  local lineBounds = self:getLineBounds(position)
  local lineCoeff = (position.y * (-0.5)) / (self.dimensions.y / 2) + 0.5
  local farCoeff = (position.x * 0.5) / (self.dimensions.x / 2) + 0.5

  print(position.x, self.dimensions.x)

  return Position(
    lineCoeff * (lineBounds.right - lineBounds.left) + lineBounds.left,
    farCoeff * (Court.ScreenBounds.UpLeft.y - Court.ScreenBounds.DownLeft.y) + Court.ScreenBounds.DownLeft.y
  )
end

return Court
