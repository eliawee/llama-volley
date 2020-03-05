local baton = require("lib.baton")

local players = {
  baton.new(
    {
      controls = {
        left = {"key:a", "key:q", "axis:leftx-"},
        right = {"key:d", "axis:leftx+"},
        up = {"key:w", "key:z", "axis:lefty-"},
        down = {"key:s", "axis:lefty+"},
        action = {"key:space", "button:a"}
      },
      joystick = love.joystick.getJoysticks()[1]
    }
  ),
  baton.new(
    {
      controls = {
        left = {"key:left", "axis:leftx-"},
        right = {"key:right", "axis:leftx+"},
        up = {"key:up", "axis:lefty-"},
        down = {"key:down", "axis:lefty+"},
        action = {"key:return", "key:kpenter", "button:a"}
      },
      joystick = love.joystick.getJoysticks()[2]
    }
  )
}

return {
  players = players,
  anyPressed = function(name)
    return players[1]:pressed(name) or players[2]:pressed(name)
  end,
  anyDown = function(name)
    return players[1]:down(name) or players[2]:pressed(name)
  end
}
