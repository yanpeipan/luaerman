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
local url = require"socket.url"
local MessageModel = require"messageModel"
local SessionModel = require"sessionModel"
local eventCodes = require'eventCodes'
local User = require'User'

--client全局变量
local _g
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
function init(device, path, wsProtocol)
  _g = {}
  _g.ws = {}
  _g.api = {}
  _g.user = {}
  _g.currentUser = User.new()
  _g.appkey = appkey
  _g.device = device or ''
  _g.json = 'msgpack'
  _g.ws.protocol = wsProtocol or 'riverrun.binary.msgpack'
  --Sqlite
  _g.sqlite = {['path']=path}
  _g.messageModel = MessageModel.new(_g.sqlite)
  _g.sessionModel = SessionModel.new(_g.sqlite)
  _g.messageModel:init()
  _g.sessionModel:init()
  --WS参数
  _g.ws.host = 'ws.me2.tv'
  _g.ws.host = '192.168.1.16'
  _g.ws.port = '7272'
  _g.ws.scheme = 'ws'
  _g.ws.timeout = nil
  --API参数
  _g.api.host = 'ws.me2.tv'
  _g.api.host = '192.168.1.16'
  _g.api.port = '55252'
  _g.api.scheme = 'http'
  _g.api.key = key or 'woRKeRmAn'
  --设置csjon
  cjson.encode_sparse_array(true)
end

--连接服务器
--
--
function connectServer()
  local options = {timeout=_g.ws.timeout}
  _g.client = websocket.client:new(options)
  local wsProtocol = _g.ws.protocol
  local wsUrl = getWSUrl()
  local code, err = _g.client:connect(wsUrl, wsProtocol);
  return code
end

--获取WS服务URI
--
--
function getWSUrl()
  local wsUrl = url.build({
    host = _g.ws.host,
    port = _g.ws.port,
    scheme = _g.ws.scheme,
    query = 'device=' .. _g.device
  })
  return wsUrl
end

--获取API请求URI
--
--
function getApiUrl(path, params)
  params = params or {}
  params.time = params.time or os.time()
  params.token = md5.sumhexa(md5.sumhexa(_g.api.key) .. params.time)
  --local apiUrl = _g.api .. path .. '?'
  local query = ''
  for k,v in pairs(params) do
    query = query .. k .. '=' .. v .. '&'
  end
  local apiUrl = url.build({
    host = _g.api.host,
    scheme = _g.api.scheme,
    port = _g.api.port,
    path = path,
    query = query,
  })
  return apiUrl
end

--获取服务器对应的receiver&receiver_type
--
function getReceiver(target, targetType)
  local receiver
  local receiver_type
  if target_type ==0 then
    receiver = target
    receiverType = 2
  else
    receiver = math.floor(target / 100)
    receiver_type = target % 100
  end
  return receiver, receiver_type
end

--获取亲加对应的target&targetType
--
function getTarget(receiver, receiver_type)
  local target
  local targetType
  if receiver_type == 2 then
    target = receiver
    targetType = 0
  else
    target = receiver * 100 + receiver_type
    targeType = 2
  end
  return target, targeType
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
--@example joinGroup(1001) or joinGroup(10, 1)
function joinGroup(...)
  if #arg == 1 then
    send({1001, arg[1]})
  elseif #arg ==2 then
    send({1001, {receiver=arg[1], receiver_type=arg[2]}})
  end
end

--离开群
--
--
function leaveGroup(...)
  if #arg == 1 then
    send({1002, arg[1]})
    print('client.lua leaveGroup param arg[1]: '..arg[1])
  elseif #arg ==2 then
    send({1002, {receiver=arg[1], receiver_type=arg[2]}})
    print('client.lua leaveGroup param arg[1]: '..arg[1]..";arg[2]:"..arg[2])
  end
end

--发送消息
--
--
function sendText(target, targetType, text)
  if _g.currentUser.isLogin then
    local sender = _g.currentUser:get('id')
    local receiver, receiverType = getReceiver(target, targetType)
    local message = {
      sender = sender
    }
    if type(text) == 'table' then
      message.msg = msgpack.pack(text)
    else
      message.msg = text
    end
    local id, errmsg = _g.sessionModel:add(sender, target, targetType)
    message.msgid = id
    send({1004, {['receiver']=receiver, ['receiver_type']=receiverType}, message})
    --if receiver_type == 2 then
    --  send({1004, receiver, messsage})
    --elseif receiver_type == 0 then
    --  send({1004, {['receiver']=receiver, ['receiver_type']=2}, message})
    --end
    --onSendMessage(0, message)
    --
  end
end

--请求获取群成员列表
--
--
function requestGroupMemberlist(groupId, pageIndex)
  send({1005, groupId, pageIndex})
end

--清除缓存
--
--
function clearCache()
  _g.messageModel:delete(uid)
  _g.sessionModel:delete(uid)
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
function receive_sync()
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
    onMessage(message)
  end
end

function receive()
  if _g.client ~= nil and _g.client.state == 'OPEN' then
    local recvt,sendt,status = socket.select({_g.client.sock},nil,nil)
    if #recvt > 0 then
      receive_sync()
    end
    elseif _g.client.state ~= 'RECONNECTING' then
      _g.client.state = 'RECONNECTING'
      socket.sleep(5)
      local status = connectServer()
      local code
      if status == true then
        code = codes['CODE_OK']
      else
        code = codes['CODE_NETWORK_DISCONNECTED']
      end
      onDelegate(eventCodes['GotyeEventCodeReconnecting'], {['code']=code})
  end
end

--On Message
--
--
function onMessage(message)
  if type(message) == 'table' and #message > 0 then
    local code = assert(message[1])
    print("onmessage code:"..code)
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

--获取对应消息send的所有未读个数
--targetType ：0：单聊； 1：聊天室； 2：群聊
--
function getUnreadMsgcountByType(targetType)
  local count = 0
  local uid = _g.currentUser:get('id')
  local _, receiverType = getReceiver(0, targetType)
  if uid ~= nil then
    local params = {['chatstatus'] = _g.messageModel.status.unread, ['receiver_type'] = receiverType}
    local url = getApiUrl('/message/list/' .. uid, params)
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
  local count = 0
  if _g.currentUser.isLogin then
    local uid = _g.currentUser:get('id')
    local receiver, receiverType = getReceiver(target, targetType)
    local params = {['sender'] = receiver, ['receiver_type']=receiverType, ['chatstatus'] = _g.messageModel.status.unread}
    local url = getApiUrl('/message/list/' .. uid, params)
    local result = httpclient:get(url)
    if result ~= nil then
      count = result.total or 0
    end
  end
  return count
end

--将和某个聊天对象的全部消息标记为已读
--
--
function markMessagesAsread(target, targetType, status)
  if _g.currentUser.isLogin then
    local uid = _g.currentUser:get('id')
    local resultTable = {}
    local apiUrl = getApiUrl('/message/' .. target)
    local data = ''
    local result = httpclient:put(apiUrl, data)
    if result ~= nil and result.code == 200 then
      resultTable = cjson.decode(result.body) or {}
    end
  end
end

--获取对应Target的最后一条消息
--
--
function getLastMessage(target, targetType)
  if _g.currentUser.isLogin then
    local uid = _g.currentUser:get('id')
    local receiver, receiverType = getReceiver(target, targetType)
    local params = {['sender']=uid, ['receiver']=receiver, ['receiver_type']=receiverType, ['size']=1} local url = getApiUrl('/message/' , params)
    local result = httpclient:get(url)
    if result ~= nil and result.code == 200 then
      local json = cjson.decode(result.body)
      if json ~= nil and json.messages ~= nil then
        return cjson.encode(json.messages[1])
      end
    end
  end
end

--删除会话
--
--
function deleteSession(target, type, removeMessage)
  if _g.currentUser.isLogin then
    local uid = _g.currentUser:get('id')
    local columns = _g.sessionModel:delete(uid, target, type)
  end
end

--获取回话列表
--
--
function getSessionlist()
  local uid = _g.currentUser:get('id')
  local sessionList = {}
  local errmsg
  if uid ~= nil then
    sessionList,errmsg = _g.sessionModel:get(uid)
  end
  return cjson.encode(sessionList)
end

--获取用户详情
--
--
function getTargetDetail(target, type, forceRequest)
  local uid = _g.currentUser:get('id')
  local user = ''
  if uid ~= nil then
    local url = getApiUrl('/user/detail/' .. target)
    local result = httpclient:get(url)
    if result ~= nil and result.code == 200 then
      user = result.body
    end
  end
  return user
end

--是否在线
--
--
function isOnline()
  local status
  if _g.client ~= nil and _g.client.state == 'OPEN' then
    status = -1
    elseif _g.currentUser.isLogin then
      status = 1
    else
      status = 0
    end
    return status
  end

  --激活对应的会话session（这样收到的对应该Target的消息自动标记为已读）
  --
  --
  function activeSession(target, type)
  end
