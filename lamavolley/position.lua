local Object = require("lib.classic")

local Position = Object:extend()

function Position:new(x, y, z)
  self.x = x
  self.y = y
  self.z = z
end

return Position
