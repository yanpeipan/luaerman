local m = {}
local ChatTarget = {}

m.new = function(target, type, name)
  self = {}
  self.Id = target
  self.type = type 
  self.name = name
  self.types = {
    user=0,
    room=1,
    group=2
  }
  setmetatable(self, {__index = ChatTarget})
  return self
end

function ChatTarget:get(key)
  return rawget(self, key)
end

function ChatTarget:set(key, value)
  return rawset(self, key, value)
end

return m
