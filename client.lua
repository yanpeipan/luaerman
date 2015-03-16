local socket = require"socket"
local websocket = require"websocket"
local frame = require"websocket.frame"
local protocol = require"protocol"
local codes = require"code"
local msgpack = require"MessagePack"
local cjson = require"cjson"

local _g = {}

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

  for k,v in pairs(_g.ws) do
    print(k, v)
  end

  local code = codes['CODE_VERIFYFAILED']

  local _,err,html = _g.client:connect(_g.url, _g.protocol);

  if err ~= nil then
    if err == 'host or service not provided, or not known' then
      code = codes['CODE_NETWORK_DISCONNECTED']
    else
      code = codes['CODE_VERIFYFAILED']
    end
  else
    code = codes['CODE_OK']
    --_g.fd = _g.client.sock:getfd()
  end

  return code
end

--指令集
--
--
--local commands = commandList
local commands_do = {

  ["LOGIN"] = function(value, ...)
    local msg = {1007, value['usr'], value['psw']}
    send(msg)
  end,

}

--调用指令
--
--cName string 指令名
function call(cName,cValue)
  if type(commands_do[cName]) == "function" then
    cValue = assert(cjson.decode(cValue))
    commands_do[cName](cValue, unpack(cValue))
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
      message = assert(msgpack.pack(message))
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
    elseif message ~= nil then
      message = assert(msgpack.unpack(message))
      if type(message) == 'table' then
        for k, v in pairs(message) do
          print(k, v)
        end
      end
    end
    --p.parse(message)
  end
end

init()
--call('LOGIN', cjson.encode({['usr']='1506334335', ['psw']='295079529'}))
call('LOGIN', cjson.encode({['usr']='18600218174', ['psw']='19891015'}))
