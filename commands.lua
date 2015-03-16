local socket = require"socket"
local websocket = require"websocket"
local protocol = require"protocol"
local codes = require"code"
local mp = require"MessagePack"

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

  if context.url ~= nil and context ~= '' then
    _g.url = context.url
  else
    _g.url = 'ws://ws.me2.tv:7272'
  end

  if context.protocol ~= nil and context.protocol ~= '' then
    _g.ws.protocol = context.protocol
  else
    _g.ws.protocol = 'RiverrunBinary'
  end

  if context.timeout ~= nil and context.timeout ~= '' then
    _g.ws.timeout = context.timeout
  end

  _g.client = websocket.client:new(_g.ws)

  for key, value in pairs(_g.client) do
    --print(key, value)
  end

  local code = codes['CODE_VERIFYFAILED']

  local _,err,html = _g.client:connect(_g.url);

  if err ~= nil then
    if err == 'host or service not provided, or not known' then
      code = codes['CODE_NETWORK_DISCONNECTED']
    end
  else
    code = codes['CODE_OK']
    --_g.fd = _g.client.sock:getfd()
  end

  return code, _g.client
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
    error('Err: ' .. cName ..' not found!')
    return nil
  end
end

--发送消息
--
--
function send(message)
  if _g.client ~= nil and _g.client.state == 'OPEN' then
    --_g.client:send(message)
  end
end

--接受消息
--
--
function receive()
  if _g.client ~= nil and _g.client.state == 'OPEN' then
    local message = _g.client:receive()
    --p.parse(message)
  end
end

init()
call('LOGIN', '111111', '2222222')
