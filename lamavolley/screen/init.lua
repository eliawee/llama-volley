local Object = require("lib.classic")

local Screen = Object:extend()

local navigationListener = nil

function Screen.onNavigate(listener)
  navigationListener = listener
end

function Screen:update()
end

function Screen:draw()
end

function Screen:navigate(name)
  if navigationListener then
    navigationListener(name)
  end
end

return Screen
