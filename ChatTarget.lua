local m = {}

m.new = function(target, target_type)
  self = {}
  self.types ={
    user=0,
    room=1,
    group=2
  }
  setmetatable(self, {__index = ChatTarget})
  return self
end

function ChatTarget:get()
end

return m
