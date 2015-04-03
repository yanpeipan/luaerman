m.new = function(user)
  local self = {}
  self.user = user or {}
  setmetatable(self, {__index = user})
  return self
end

function user:get(key)
end

function user:isLogin()
end

return m
