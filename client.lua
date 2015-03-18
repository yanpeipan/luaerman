local socket = require"socket"
local websocket = require"websocket"
local frame = require"websocket.frame"
local protocol = require"protocol"
local codes = require"code"
local msgpack = require"MessagePack"
local cjson = require"cjson"

local _g = {}
local protocol = protocol:new()

--init
--
--context table 为上下文环境
--appkey string API key
--return void
function init(context, appkey)

  context = context or {}
  _g.appkey = appkey
  _g.ws = {}
  _g.device = context.device or ''
  _g.url = context.url or  'ws://192.168.1.16:7272'
  _g.url = _g.url .. '?device=' .. _g.device
  --_g.url = context.url or  'ws://ws.me2.tv:7272'
  _g.protocol = context.protocol or 'RiverrunBinary'
  _g.ws.timeout = context.timeout or nil
  _g.json = context.json or 'msgpack'
  return true
end

--连接服务器
--
--
function connectServer()
  _g.client = websocket.client:new(_g.ws)
  local code, err = _g.client:connect(_g.url, _g.protocol);
end

--用户登录
--
--
function login(usr, psw)
  send({1007, usr, psw})
end

--用户注销
--
--
function logout()
  send({1008})
end

--加入群
--
--
function joinGroup(...)
  if #arg == 1 then
    send({1001, arg[1]})
  elseif #arg ==2 then
    send({1001, {vid=arg[1], vtype=arg[2]}})
  end
end

--离开群
--
--
function leaveGroup(...)
  if #arg == 1 then
    send({1002, arg[1]})
  elseif #arg ==2 then
    send({1002, {vid=arg[1], vtype=arg[2]}})
  end
end

--发送消息
--
--
function sendText(receiver, type, text, ext, len)
  if type(text) == 'string' then
    cjson.decode(text)
  end
  if type(text) == 'table' then
    send({1004, {receiver, type}, message})
  end
end

--清除缓存
--
--
function clearCache()
end

--设置是否每次登录后自动获取离线消息
--
--
function beginRcvOfflineMessge()
end

--指令集
--
--
--local commands = commandList
local commands_do = {

  ["LOGIN"] = function(usr, psw)
    send({1007, usr, psw})
  end,

  ["LOGOUT"] = function()
    send({1008})
  end,

  ["LOGINROOM"] = function(...)
    if #arg == 1 then
      send({1001, arg[1]})
    elseif #arg ==2 then
      send({1001, {vid=arg[1], vtype=arg[2]}})
    end
  end,

  ["LOGOUTROOM"] = function(room)
    send({1002, room})
  end,

  ["BEATS"] = function()
    send({1003})
  end,

  ["CHATMESSAGE"] = function(room, message)
    send({1004, room, message})
  end,

}

--调用指令
--
--cName string 指令名
function call(cName,...)
  if type(commands_do[cName]) == "function" then
    commands_do[cName](unpack(arg))
  else
    error('Err: ' .. cName .. ' not found!')
  end
end

--发送消息
--
--
function send(message)
  if _g.client ~= nil and _g.client.state == 'OPEN' then
    if type(message) == 'table' then
      for k,v in pairs(message) do
        print(k,v)
      end
      if _g.json == 'cjson' then
        message = assert(cjson.encode(message))
      else
        message = assert(msgpack.pack(message))
      end
      _g.client:send(message)
      receive()
    end
  end
end

--接受消息
--
--
function receive()
  if _g.client ~= nil and _g.client.state == 'OPEN' then
    local message = _g.client:receive()
    if message == '[1003]' then
      message = cjson.decode(message)
    elseif message ~= nil then
      if _g.json == 'cjson' then
        message = assert(cjson.decode(message))
      else
        message = assert(msgpack.unpack(message))
      end
    end
    onmessage(message)
  end
end

--On Message
--
--
function onmessage(message)
  if type(message) == 'table' and #message > 0 then
    local code = assert(message[1])
    local callback = protocol.parse(code)
    table.remove(message, 1)
    for k,v in pairs(message) do
      print(k,v)
    end
    callback(_g, unpack(message))
  end
end

init({device='android'})
connectServer()
login('18600218174', '19891015')
--logout()
--joinGroup(1)
--leaveGroup(1)
