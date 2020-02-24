local Object = require("lib.classic")

local SubSource = Object:extend()

local instances = {}

function SubSource.updateAll()
  for index, instance in pairs(instances) do
    instance:update()
  end
end

function SubSource:new(source, start, stop)
  self.source = source:clone()
  self.startPosition = start or 0
  self.stopPosition = stop or source:getDuration()
end

function SubSource:isRegistered()
  for index, instance in pairs(instances) do
    if instance == self then
      return true
    end
  end

  return false
end

function SubSource:register()
  if not self:isRegistered() then
    table.insert(instances, self)
  end
end

function SubSource:unregister()
  local newInstances = {}

  for index, instance in pairs(instances) do
    if not instance == self then
      table.insert(newInstances, instance)
    end
  end

  instances = newInstances
end

function SubSource:play()
  self:register()
  self.source:seek(self.startPosition, "seconds")
  self.source:play()
end

function SubSource:stop()
  if self.source:isPlaying() then
    self.source:stop()
    self:unregister()
  end
end

function SubSource:update()
  if self.source:tell("seconds") >= self.stopPosition then
    self:stop()
  end
end

return SubSource
