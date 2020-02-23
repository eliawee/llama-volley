local Object = require("lib.classic")

local Position = Object:extend()

function Position:new(x, y, z)
  self.x = x
  self.y = y
  self.z = z or 0
end

function Position:translate(x, y, z)
  self.x = self.x + (x or 0)
  self.y = self.y + (y or 0)
  self.z = self.z + (z or 0)

  return self
end

function Position:clone()
  return Position(self.x, self.y, self.z)
end

return Position
