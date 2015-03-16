local cjson  = require'cjson'
local player = require 'player'
--local metadata = player.metadata
local delegate = require "delegate"
--解析视频信息
function VIDEOINFO(array)
  local len = table.getn(array)
  if(3 == len) then
    test(">>>>>>>>>>>>>>>>>>>>>>>>>in lua protocol VIDEOINFO")
    delegate.videoInfo(cjson.encode(array[3]))
    for k,v in pairs(array[3]) do
      test("protocol VIDEOINFO k: "..k.."   v: "..v)
--      player.callback(metadata,k,v)
        player.callback(k,v)
    end
  end
  -- 旧协议
  if(2 == len) then
    CHATSYNC(array)
  end
  --table.foreach(metadata,function(i,v) print(i,v) end)
end

function VIDEOREALURL(array)
  test("VIDEOREALURL")
  local msgLen = table.getn(array)
  if(2 == msgLen) then
     delegate.realUrlInfo(cjson.encode(array[2]))
     test("===protocol.lua===realUrlInfo param======"..cjson.encode(array[2]))
  else
     delegate.realUrlInfo("")
  end
end

--其他接受到的信息解析
function WELCOME(array)
  delegate.welcome()
end

function GOODBYE(array)
  delegate.goodBye()
end


local status_delegate = {
  ["CODE_PLAY_UNSTART"] = function()
    delegate.play_unstart(1)
  end,
  
  ["CODE_PLAY_CLOSE"] = function()
    delegate.play_unstart(0)
  end,

  ["CODE_AUTH_UNLOGIN"] = function()
    delegate.auth_unlogin()
  end,

  ["CODE_AUTH_ISLOGIN"] = function()
    delegate.auth_login()
  end,

  ["CODE_CHAT_SUCCESS"] = function()
    delegate.chat_success()
  end,
}

function CHATSYNC(array)
  local status_code = array[2]
  if(type(status_delegate[status_code]) == "function") then
    status_delegate[status_code]()
  end
end


--class
local protocol = function()
  local self = {}
  self.code = {
    [1]   = HELLO,
    [2]   = WELCOME,
    [6]   = GOODBYE,
    [201] = VIDEOPLAY,
    [202] = VIDEOPAUSE,
    [203] = VIDEOSEEK,
    [204] = VIDEOSTOP,
    [205] = VIDEOSCALE,
    [206] = GETVIDEOINFO,
    [207] = VIDEOINFO,
    [208] = SETVOLUME,
    [209] = VIDEODEFINITION,
    [210] = VIDEOSOURCE,
    [211] = VIDEOBARRAGE,
    [212] = GETREALURL,
    [213] = VIDEOREALURL,
    [401] = CHATSTART,
    [402] = CHATSYNC,
    [403] = CHATSTOP,
  }

  --param:message,json raw
  self.parse = function(message)
    test("protocol parse message")
    local array = cjson.decode(message)
    --    if array ~= nil and type(array) == "table" and table.getn(array) >= 1 then
    if table.getn(array) >= 1 then
      --判断self.code
      local c = array[1]
      --print(self.code[c])
      if(type(self.code[c]) == "function") then
        self.code[c](array)
      end
    end

  end

  return self
end

return {
  new = protocol
}
