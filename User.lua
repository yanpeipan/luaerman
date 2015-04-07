local m = {}
local user = {}
m.new = function(user, isLogin)
  local self = {}
  user = user or {}
  self.id = user.id
  self.isLogin = isLogin or false
  setmetatable(self, {__index = user})
  return self
end

function user:get(key)
  return rawget(self, key)
end

function user:set(key, value)
  return rawset(self, key, value)
end

function user:isCurrentUser(uid)
  if uid == self:get('Id') then
    return true
  end
  return false
end

function user:isLogin()
  return self.isLogin
end

return m
