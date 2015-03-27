local socket = require"socket"
local websocket = require"websocket"
local frame = require"websocket.frame"
local protocol = require"protocol"
local sqlite = require"lsqlite3"
local codes = require"code"
local msgpack = require"MessagePack"
local cjson = require"cjson"
local md5 = require"md5"
local httpclient = require"httpclient".new()

local _g = {}
local protocol = protocol:new()

--getter
--
--在作用域外获取_g的值
function getter(key)
  local value = nil
  if key == nil then
    value = _g
  else
    value = rawget(_g, key)
  end
  return value
end

--init
--
--device 设备名称
--protocol 默认协议：'RiverrunBinary'
--timeout 默认不超时
--json 默认使用msgpack
--return void
function init(device, protocol, timeout, json)
  _g.appkey = appkey
  _g.ws = {}
  _g.sqlite = {path='/tmp/IMDB'}
  _g.device = device or ''
  _g.url = url or 'ws://192.168.1.16:7272'
  _g.api = url or 'http://192.168.1.16:55252'
  --_g.url = url or 'ws://ws.me2.tv:7272'
  _g.url = _g.url .. '?device=' .. _g.device
  _g.protocol = protocol or 'RiverrunBinary'
  _g.ws.timeout = timeout or nil
  _g.json = json or 'msgpack'
  _g.key = key or 'woRKeRmAn'
end

--连接服务器
--
--
function connectServer()
  _g.client = websocket.client:new(_g.ws)
  local code, err = _g.client:connect(_g.url, _g.protocol);
  return code
end

--获取API请求URI
--
--
function getApiUrl(path)
  local time = os.time()
  local token = md5.sumhexa(md5.sumhexa(_g.key) .. time)
  return _g.api .. path .. '?time=' .. time .. '&token=' .. token
end

--用户登录
--
--
function login(usr, psw)
  send({1007, usr, psw})
  return true
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
function sendText(receiver, receiverType, text)
  if type(text) == 'string' then
    text = assert(cjson.decode(text))
  end
  if type(text) == 'table' then
    local message = {}
    send({1004, {receiver, receiverType}, message})
  end
  --onSendMessage(0, message)
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

--发送消息
--
--
function send(message)
  if _g.client ~= nil and _g.client.state == 'OPEN' then
    if type(message) == 'table' then
      if _g.json == 'cjson' then
        message = assert(cjson.encode(message))
      else
        message = assert(msgpack.pack(message))
      end
      _g.client:send(message)
    end
  end
end

--调用声明函数
--
--
function call(cName,...)
  if type(_G[cName]) == "function" then
    _G[cName](unpack(arg))
  else
    error('Err: ' .. cName .. ' not found!')
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
    callback(_g, unpack(message))
  end
end

function getUser(key)
  local value = nil
  if _g ~= nil and _g.user ~= nil then
    value = _g.user[key]
  end
  return value
end

--获取对应消息类型的所有未读个数
--targetType ：0：单聊； 1：聊天室； 2：群聊
--
function getUnreadMsgcountByType(targetType)
  local count = 0
  local uid = getUser('uid')
  if uid ~= nil then
    local url = getApiUrl('/list/' .. uid)
    local result = httpclient:get(url)
    if result ~= nil then
      count = result.total or 0
    end
  end
  return count
end

--获取和某个聊天对象target（GotyeChatTarget）的未读消息数
--
--
function getUnreadMsgcount(target, targetType)
  return 0
end

--将和某个聊天对象的全部消息标记为已读
--
--
function markMessagesAsread(target, targetType)
end

--获取对应Target的最后一条消息
--
--
function getLastMessage(target, type)
end

--删除会话
--
--
function deleteSession(target, type, removeMessage)
end

--获取回话列表
--
--
function getSessionlist()
end

--获取用户详情
--
--
function getTargetDetail(target, type, forceRequest)
end

--请求获取群成员列表
--
--
function requestGroupMemberlist(groupId, pageIndex)
end

--是否在线
--
--
function isOnline()
  return _g.client ~= nil and _g.client.state == 'OPEN'
end

--激活对应的会话session（这样收到的对应该Target的消息自动标记为已读）
--
--
function activeSession(target, type)
end
