local m = {}
local User = {}
m.new = function(user, isLogin)
  local self = {}
  user = user or {}
  self.id = user.id
  self.isLogin = isLogin or false
  setmetatable(self, {__index = User})
  return self
end

function User:get(key)
  return rawget(self, key)
end

function User:set(key, value)
  return rawset(self, key, value)
end

function User:isCurrentUser(uid)
  if uid == self:get('id') then
    return true
  end
  return false
end

return m
