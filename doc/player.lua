local delegate = require "delegate"
local metadata = {
	position,
	cate,
	definition,
	max_volume,
	vtype,
	barrage,
	screen_type,
	tv_id,
	playing = '1',
	video_name,
	duration,
	source,
	volume,
	vid,
	fenji_name,
	pic
}
--实现调用到上层的具体方法
local metadata_delegate = {
	["position"] =  function(value)
		if(type(delegate.position) == "function") then
			delegate.position(value)
		end
	end,
	["cate"] =  function(value)
		if(type(delegate.cate) == "function") then
			delegate.cate(value)
		end
	end,
	["definition"] =  function(value)
		if(type(delegate.definition) == "function") then
			delegate.definition(value)
		end
	end,
	["max_volume"] =  function(value)
		if(type(delegate.max_volume) == "function") then
			delegate.max_volume(value)
		end
	end,
	["vtype"] =  function(value)
		if(type(delegate.vtype) == "function") then
			delegate.vtype(value)
		end
	end,
	["barrage"] =  function(value)
		if(type(delegate.barrage) == "function") then
			delegate.barrage(value)
		end
	end,
	["screen_type"] =  function(value)
		if(type(delegate.screen_type) == "function") then
			delegate.screen_type(value)
		end
	end,
	["tv_id"] =  function(value)
		if(type(delegate.tv_id) == "function") then
			delegate.tv_id(value)
		end
	end,
	["playing"] =  function(value)
		if(type(delegate.playing) == "function") then
			delegate.playing(value)
		end
	end,
	["video_name"] =  function(value)
		if(type(delegate.video_name) == "function") then
			delegate.video_name(value)
		end
	end,
	["duration"] =  function(value)
		if(type(delegate.duration) == "function") then
			delegate.duration(value)
		end
	end,
	["source"] =  function(value)
		if(type(delegate.source) == "function") then
			delegate.source(value)
		end
	end,
	["volume"] =  function(value)
		if(type(delegate.volume) == "function") then
			delegate.volume(value)
		end
	end,	
	["vid"] =  function(value)
		if(type(delegate.vid) == "function") then
			delegate.vid(value)
		end
	end,
	["fenji_name"] =  function(value)
		if(type(delegate.fenji_name) == "function") then
			delegate.fenji_name(value)
		end
	end,
	["pic"] =  function(value)
		if(type(delegate.pic) == "function") then
			delegate.pic(value)
		end
	end,
}

local callback = function(metadata,k,v)
	if(metadata[k] ~= v) then
		metadata[k] = v
		--调用代理类，通知上层
		if(type(metadata_delegate[k]) == "function") then
			metadata_delegate[k](v)
		end
	end
end


return {
    metadata = metadata,
    callback = callback
}