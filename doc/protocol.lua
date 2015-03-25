local cjson  = require'cjson.safe'
local player = require 'player'
local metadata = player.metadata
local delegate = require "delegate"


--class
--
--
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
    [401] = CHATSTART,
    [402] = CHATSYNC,
    [403] = CHATSTOP,
  }

  --param:message,json raw
  self.parse = function(message)
    local array = cjson.decode(message)
    if array ~= nil and type(array) == "table" and table.getn(array) >= 1 then
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
