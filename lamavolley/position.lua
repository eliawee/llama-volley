local Object = require("lib.classic")

local Position = Object:extend()

function Position:new(x, y, z)
  self.x = x
  self.y = y
  self.z = z or 0
end

return Position
