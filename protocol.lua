local cjson  = require'cjson'
local codes = require'code'
local msgpack = require'MessagePack'
local eventCodes = require'eventCodes'
local User = require'User'

function javaCallbacks()
end

function onDelegate(event, table)
  local data = table or {}
  if type(data) == 'table' then
    data = cjson.encode(data)
  else
    data = cjson.encode({})
  end

  --debug
  local eventName
  for k,v in pairs(eventCodes) do
    if v == event then
      eventName = k
    end
  end
  print("protocol.lua onDelegate event:"..eventName..";data: "..data)
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
      user = user or {}
      group = group or {}
      if _.currentUser:isCurrentUser(user.uid) then
        onDelegate(eventCodes['GotyeEventCodeJoinGroup'], {["code"]=codes["CODE_OK"], ["group"]=group})
      else
        onDelegate(eventCodes['GotyeEventCodeUserJoinGroup'], {['group']=group, ['user']=user})
      end
    end,
    [1002] = function(_, group, user)
      user = user or {}
      group = group or {}
      if _g.currentUser.isCurrentUser(user.uid) then
        onDelegate(eventCodes['GotyeEventCodeLeaveGroup'], {['code']=codes["CODE_OK"], ['group']=group})
      else
        onDelegate(eventCodes['GotyeEventCodeUserLeaveGroup'], {['group']=group, ['user']=user})
      end
    end,
    [1003] = function(_)
      local message = msgpack.pack({1003})
      _.client:send(message)
    end,
    [1004] = function(_, target, message)
      local sender = {['id']=message.sender, ['type']=0}
      local target, targetType = getTarget(target.receiver, target.receiver_type)
      local receiver = {['id']=target, ['type']=targeType}
      local data = {['receiver']=receiver, ['sender']=sender, ['message']=message.msg}
      if _.currentUser:isCurrentUser(message.sender) then
        onDelegate(eventCodes['GotyeEventCodeSendMessage'], data)
      else
        _.sessionModel:add(sender.id, target, targetType, target)
        onDelegate(eventCodes['GotyeEventCodeReceiveMessage'], data)
      end
    end,
    [1005] = function(_, target, members)
      onDelegate(eventCodes['GotyeEventCodeGetGroupUserList'], {['target']=target, ['members']=members})
    end,
    [1007] = function(_, code, user)
      if code == 0 then
        _.currentUser = User.new(user, true)
      end
      onDelegate(eventCodes['GotyeEventCodeLogin'], {['code']=code, ['user']=user})
    end,
    [1008] = function(_, code)
      if code == 0 then
        _.user = {isLogin=false}
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
