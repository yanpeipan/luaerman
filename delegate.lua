-- 处理方法中调用在java中注册的方法

local delegate = {

  login = function(code, user)
    onLogin(code, user)
  end,

  welcome = function(value)
   onWelcome()
  end,
  goodBye = function(value)
   onGoodBye()
  end,
  
  videoInfo = function(value)
   test("delegate============================")
--   value is json raw data
     onGetRemoteVideo(value)
  end,
  
  realUrlInfo = function(value)
   test("delegate===============realUrlInfo============="..value)  
   
   onGetRealUrl(value)
  end,
  
  play_unstart = function(value)
   test("delegate====================onChatSync_Play_Unstart========")
   onChatSync_Play_Unstart(value)
  end,

  auth_unlogin = function(value)
    test("delegate====================onChatSync_Auth_Unlogin========")
    onChatSync_Auth_Unlogin()
  end,
  auth_login = function(value)
    test("delegate====================auth_login========")
    onChatSync_Auth_Login()
  end,
  chat_success = function(value)
    test("delegate====================chat_success========")
    onChatSyn_Chat_Success()
  end,
  cate= function(value)
    test("delegate====================onRemoteCateChange========")
    onRemoteCateChange(value)
  end,
  definition= function(value)
    test("delegate====================onDefinition========")
    onDefinition(value)
    test(value)
  end,
  
  max_volume= function(value)
   test("delegate====================onMax_volume========")
   onMax_volume(value)
   test(value)
  end,
  vtype= function(value)
    test("delegate====================onVType========")
    onVType(value)
   test(value)
  end,
  barrage= function(value)
    test("delegate====================onBarrage, code: "..value)
--    onBarrage(value)
  end,
  screen_type= function(value)
   test("delegate====================onScreenType========")
   onScreenType(value)
   test(value)
  end,
  tv_id= function(value)
    test("delegate====================onTV_ID========")
    onTV_ID(value)
   test(value)
  end,
  playing = function(value)
    test("delegate====================onPlayPause="..value)
--    onPlayPause(value)
  end,
  video_name= function(value)
    test("delegate====================onVideoName========")
    onVideoName(value)
   test(value)
  end,
  duration= function(value)
    test("delegate====================onDuration========")
--    onDuration(value)
  end,
  source= function(value)
    test("delegate====================onSource========")
    onSource(value)
   test(value)
  end,
  volume= function(value,maxvolume)
    test(value.."sdads "..maxvolume)
 
    onVolume(value,maxvolume)
  end,
  
  position = function(value,duration)
   test("delegate====================onRemotePositionChange========, position: "..value..",duration: "..duration)
--   onRemotePositionChange(value,duration)
  end,
  vid= function(value)
    test("delegate====================onVid========")
    onVid(value)
    test(value)
  end,
  fenji_name= function(value)
    test("delegate====================onFenjiName========")
    onFenjiName(value)
   test(value)
  end,
  pic= function(value)
   test("delegate====================onPicUrl========")
   onPicUrl(value)
   test(value)
  end,
  sourcename= function(value)
   test("delegate====================onPicUrl========")
   onSourcename(value)
   test(value)
  end
}

return delegate
