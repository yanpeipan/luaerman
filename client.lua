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
  _g.url = context.url or  'ws://192.168.1.16:7272'
  --_g.url = context.url or  'ws://ws.me2.tv:7272'
  _g.protocol = context.protocol or 'RiverrunBinary'
  _g.ws.timeout = context.timeout or nil
  _g.json = context.json or 'msgpack'
  _g.client = websocket.client:new(_g.ws)

  local code = codes['CODE_VERIFYFAILED']

  local _,err = _g.client:connect(_g.url, _g.protocol);

  return _
end

--指令集
--
--
--local commands = commandList
local commands_do = {

  ["LOGIN"] = function(usr, psw)
    local msg = {1007, usr, psw}
    send(msg)
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
    callback(unpack(message))
  end
end

init()
call('LOGIN', '18600218174', '19891015')
