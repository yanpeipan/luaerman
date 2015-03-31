local cjson  = require'cjson'
local codes = require'code'
local msgpack = require'MessagePack'
local eventCodes = require'eventCodes'

function onDelegate(event, table)
  local data = table or {}
  if type(data) == 'table' then
    data = cjson.encode(data)
  else
    data = cjson.encode({})
  end
  print(event, data)
  javaCallbacks(event,data)
end

-- Protocol
--
--
local protocol = function()

  local self = {}

  self.codes = {
    [0] = function()
    end,
    --join group
    --user = {'icon', 'name', 'nickname', 'uid'} or {}
    [1001] = function(_, group, user)
      if user ~= nil then
        if user.uid == nil or user.uid ~= _.user.uid then
          onDelegate(eventCodes['GotyeEventCodeJoinGroup'], {["code"]=codes["CODE_OK"], ["group"]=group})
        else
          onDelegate(eventCodes['GotyeEventCodeUserJoinGroup'], {['group']=group, ['user']=user})
        end
      end
    end,
    [1002] = function(_, group, user)
      if user ~= nil then
        if user.uid == nil or user.uid ~= _.user.uid then
          onDelegate(eventCodes['GotyeEventCodeLeaveGroup'], {['code']=codes["CODE_OK"], ['group']=group})
        else
          onDelegate(eventCodes['GotyeEventCodeUserLeaveGroup'], {['group']=group, ['user']=user})
        end
      end
    end,
    [1003] = function(_)
      local message = msgpack.pack({1003})
      _.client:send(message)
    end,
    [1004] = function(_, target, message)
      onDelegate(eventCodes['GotyeEventCodeReceiveMessage'], {['target']=target, ['message']=message})
    end,
    [1005] = function(_, target, members)
      onDelegate(eventCodes['GotyeEventCodeGetGroupUserList'], {['target']=target, ['members']=members})
    end,
    [1007] = function(_, code, user)
      if code == 0 then
        _.user = user
      end
      onDelegate(eventCodes['GotyeEventCodeLogin'], {['code']=code, ['user']=user})
    end,
    [1008] = function(_, code)
      if code == 0 then
        _.user = nil
      end
      onDelegate(eventCodes['GotyeEventCodeLogout'], {['code']=code})
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
