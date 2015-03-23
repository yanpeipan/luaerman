local cjson  = require'cjson'
local codes = require'code'

function delegate(event,code,...)
  print(event, code)
  if #arg > 0 then
    print(sprint(arg))
  end
end

function sprint(value)
  local string = ''
  if type(value) == 'table' then
    string = '{\n'
    for k, v in pairs(value) do
      string = string .. k .. ':' .. sprint(v) .. '\n'
    end
    string = string .. '\n}'
  elseif type(value) == 'boolean' then
    if true == value then string ='true' else string = 'false' end
  else
    string = value
  end
  return string
end

-- Protocol
--
--
local protocol = function()

  local self = {}

  self.codes = {
    [0] = function()
    end,
    [1001] = function(_, group, user)
      if user ~= nil then
        if user.uid == nil or user.uid ~= _.user.uid then
          delegate('GotyeEventCodeJoinGroup', codes["CODE_OK"], group)
        else
          delegate('GotyeEventCodeUserJoinGroup', group, user)
        end
      end
    end,
    [1002] = function(_, group, user)
      if user ~= nil then
        if user.uid == nil or user.uid ~= _.user.uid then
          delegate('GotyeEventCodeLeaveGroup', codes["CODE_OK"], group)
        else
          delegate('GotyeEventCodeUserLeaveGroup', group, user)
        end
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
    [1007] = function(_, code, user)
      if code == 0 then
        _.user = user
      end
      delegate('GotyeEventCodeLogin', code, cjson.encode(user))
    end,
    [1008] = function(_, code)
      if code == 0 then
        _.user = nil
      end
      delegate('GotyeEventCodeLogout', code)
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
