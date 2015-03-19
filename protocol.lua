local cjson  = require'cjson'

function delegate(event,code,...)
end

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
        delegate('GotyeEventCodeUserJoinGroup', code, group, user)
      else
        delegate('GotyeEventCodeJoinGroup', code, group)
      end
    end,
    [1002] = function()
      if user ~= nil and user.uid ~= _.user.uid then
        delegate('GotyeEventCodeUserLeaveGroup', code, group, user)
      else
        delegate('GotyeEventCodeLeaveGroup', code, group)
      end
    end,
    [1003] = function(_)
    end,
    [1004] = function(_, target, message)
      delegate('GotyeEventCodeReceiveMessage', target, message)
    end,
    [1005] = function(_, target, members)
      delegate('GotyeEventCodeGetGroupUserList', target, members)
    end,
    [1007] = function(_, response)
      if response.code == 0 then
        _.user = response.user
      end
      delegate('GotyeEventCodeLogin', response.code, cjson.encode(response.user))
    end,
    [1008] = function()
      delegate('GotyeEventCodeLogout')
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
