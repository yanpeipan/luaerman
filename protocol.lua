local cjson  = require'cjson'
local delegate = require "delegate"

-- Protocol
--
--
local protocol = function()

  local self = {}

  self.codes = {
    [0] = function()
    end,
    [1001] = function(_, room, user)
      if user ~= nil and user.uid ~= _.user.uid then
        delegate.onUserJoinGroup(code, group)
      else
        delegate.onJoinGroup()
      end
    end,
    [1002] = function()
      delegate.onUserLeaveGroup()
    end,
    [1003] = function()
      delegate.onBeat()
    end,
    [1004] = function(_)
      delegate.onReceiveMessage()
    end,
    [1005] = function(_)
      delegate.onGetGroupMemberList()
    end,
    [1007] = function(_, response)
      if _ ~= nil and response.code == 0 then
        _.user = response.user
      end
      delegate.onLogin(response.code, cjson.encode(response.user))
    end,
    [1008] = function()
      --delegate.onLogout()
    end,
  }

  --Parse
  --
  --
  self.parse = function(code)
    if code ~= nil and type(self.codes[code]) == "function" then
      return self.codes[code]
    else
      return self.codes[0]
    end
  end
  return self
end

return {
  new = protocol
}