local delegate = require "delegate"
local metadata = {
  cate="",
  definition="",
  max_volume="15",
  vtype="",
  barrage="",
  screen_type="",
  tv_id="",
  playing ="",
  video_name="",
  duration="",
  source="",
  volume="",
  vid="",
  fenji_name="",
  pic="",
  sourcename="",
  url="",
  html_url="",
  tv_vid="",
  fenji_id="",
  position=""
}
--实现调用到上层的具体方法
local metadata_delegate = {
  ["sourcename"] = function(value)
    test("sourcename--"..value)
    if(type(delegate.cate) == "function") then
    --      delegate.sourcename(value)
    end
  end,
  ["cate"] = function(value)
    test("cate--"..value)
    if(type(delegate.cate) == "function") then
    --      delegate.cate(value)
    end
  end,
  ["definition"] = function(value)
    test("definition--"..value)
    if(type(delegate.definition) == "function") then
    --      delegate.definition(value)
    end
  end,
  ["max_volume"] = function(value)
    test("max_volume--"..value)
    if(type(delegate.max_volume) == "function") then
    --      delegate.max_volume(value)
    end
  end,
  ["vtype"] = function(value)
    test("vtype--"..value)
    if(type(delegate.vtype) == "function") then
    --      delegate.vtype(value)
    end
  end,
  ["barrage"] = function(value)
    test("barrage--"..value)
    if(type(delegate.barrage) == "function") then
--       delegate.barrage(value)
    end
  end,
  ["screen_type"] = function(value)
    test("screen_type--"..value)
    if(type(delegate.screen_type) == "function") then
    --      delegate.screen_type(value)
    end
  end,
  ["tv_id"] = function(value)
    test("tv_id--"..value)
    if(type(delegate.tv_id) == "function") then
    --      delegate.tv_id(value)
    end
  end,
  ["playing"] = function(value)
    test("playing--"..value)
    if(type(delegate.playing) == "function") then
--       delegate.playing(value)
    end
  end,
  ["video_name"] = function(value)
    test("video_name--"..value)
    if(type(delegate.video_name) == "function") then
    --      delegate.video_name(value)
    end
  end,
  ["duration"] = function(value)
    test("duration==="..value)
    if(type(delegate.duration) == "function") then
--       delegate.duration(value)
    end
  end,
  ["source"] = function(value)
    test("source--"..value)
    if(type(delegate.source) == "function") then
    --      delegate.source(value)
    end
  end,
  ["volume"] = function(value,maxvolume)
    test("volume--"..value)
    if(type(delegate.volume) == "function") then
       delegate.volume(value,maxvolume)
    end
  end,
  ["position"] = function(value,duration)
    test("position--****"..value..", duration: "..duration)
    if(type(delegate.position) == "function") then
--       delegate.position(value,duration)
    end
  end,
  ["vid"] = function(value)
    test("vid--"..value)
    if(type(delegate.vid) == "function") then
    --      delegate.vid(value)
    end
  end,
  ["fenji_name"] = function(value)
    test("fenji_name--"..value)
    if(type(delegate.fenji_name) == "function") then
    --      delegate.fenji_name(value)
    end
  end,
  ["pic"] = function(value)
    test("pic--"..value)
    if(type(delegate.pic) == "function") then
    --      delegate.pic(value)
    end
  end,
  ["url"] = function(value)
    test("pic--"..value)
    if(type(delegate.pic) == "function") then
    --      delegate.pic(value)
    end
  end,
  ["html_url"] = function(value)
    test("pic--"..value)
    if(type(delegate.pic) == "function") then
    --      delegate.pic(value)
    end
  end,
  ["tv_vid"] = function(value)
    test("pic--"..value)
    if(type(delegate.pic) == "function") then
    --      delegate.pic(value)
    end
  end,
  ["fenji_id"] = function(value)
    test("pic--"..value)
    if(type(delegate.pic) == "function") then
    --      delegate.pic(value)
    end
  end,
}

--local callback = function(metadata,k,v)
local callback = function(k,v)
  if(metadata[k] ~= v) then
    metadata[k] = v
    --调用代理类，通知上层
    if(type(metadata_delegate[k]) == "function") then
      test("player call back..call function:  "..k)
      if(k=="volume") then
        test("k=volume, max_volume: "..metadata["max_volume"])
        metadata_delegate[k](v,metadata["max_volume"])
      end
      if (k=="position") then
        test("k=position:"..v..", duration: "..metadata["duration"])
        metadata_delegate[k](v,metadata["duration"])
      end
      if(k~="volume" and k~="position") then
        test("callback in lua function name "..k..",  function param: "..v)
        metadata_delegate[k](v)
      end
    else
      test("callback in lua not a function name "..k)
    end
  end
end


return {
  metadata = metadata,
  callback = callback
}
