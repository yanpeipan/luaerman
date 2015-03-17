local socket = require "socket"
local websocket = require'websocket'
local protocol = require "protocol"
local client = websocket.client.new()
local p = protocol.new()
local _isConnected = 0


--指令集
--
--
--local commands = commandList


local commands_do = {

    ["HELLO"] =  function(value)
      client.send(client,'[1]');
      test("hello was send")
      test(client.state)
    end,
    ["GOODBYE"] =  function(value)
      client.send(client,'[6]');
    end,
    ["PLAY"] =  function(value)
      client.send(client,'[201]');
    end,
    ["PAUSE"] =  function(value)
      client.send(client,'[202]');
      test("lua pause")
    end,

    ["SEEK"] =  function(value)
      if(value == nil) then
        client.send(client,'[203]');
      else
        local seekmsg = cjson.encode({203,tonumber(value)})
        test("seekMsg"..seekmsg)
        client.send(client,seekmsg)
      end
    end,

    ["VOLUME"] = function(value)

      if(value == nil) then
        client.send(client,"[208]");
      else
        local volumeMsg = cjson.encode({208,tonumber(value)})
        client.send(client,volumeMsg);
        test("volumeMsg"..volumeMsg)
      end
    end,

    ["STOP"] =  function(value)
      client.send(client,'[204]');
      test("lua stop")
    end,

    ["SCALE"] = function(value)

      if(value == nil) then
        client.send(client,"[205]");
        test('[205]')
      else
        local scaleMsg = cjson.encode({205,value})
        client.send(client,scaleMsg);
        test("scaleMsg"..scaleMsg)
      end
    end,

    ["GETINFO"] = function(value)
      client.send(client,'[206]');
      test("lua GETINFO")
    end,

    ["DEF"] = function(value)

      if(value ~= nil) then
        local defMsg = cjson.encode({209,value})
        client.send(client,defMsg);
        test("defMsg"..defMsg)
      end
    end,

    ["SOURCE"] = function(value)

      if(value ~= nil) then
        local sourceMsg = cjson.encode({210,value})
        client.send(client,sourceMsg);
        test("sourceMsg"..sourceMsg)
      end
    end,

    ["BARRAGE"] = function(value)

      if(value ~= nil) then
        local sourceMsg = cjson.encode({211,tonumber(value)})
        client.send(client,sourceMsg);
        test("BARRAGE"..sourceMsg)
      end
    end,

    ["CHATSTART"] = function(value)

      if(value ~= nil) then
        local chatStart = cjson.encode({401,value})
        client.send(client,chatStart);
        test("sourceMsg"..chatStart)
      end
    end,

    ["CHATSTOP"] = function(value)

      if(value ~= nil) then
        local chatStop = cjson.encode({403,value})
        client.send(client,chatStop);
        test("sourceMsg"..chatStop)
      end
    end,
    ["GETREALURL"] = function(value)
      if(value ~= nil) then
        local getRealUrlMsg = cjson.encode({212,cjson.decode(value)})
        test("==========in client.lua ==== getRealUrlMsg"..getRealUrlMsg)        
        client.send(client,getRealUrlMsg);
      end
    end,

    ["START_STORE_VIDEO"] = function(value)

      if(value ~= nil) then
        local start_stroe_video = cjson.encode({201,cjson.decode(value)})
        client.send(client,start_stroe_video);
        test("start_stroe_video"..start_stroe_video)
      end
    end,

    ["START_BILL_VIDEO"] = function(value)
      if(value ~= nil) then
        local START_BILL_VIDEO = cjson.encode({201,cjson.decode(value)})
        client.send(client,START_BILL_VIDEO);
        test("START_BILL_VIDEO"..START_BILL_VIDEO)
      end
    end,
    ["CLOSE_WSCONN"] =  function(value)
       test("!!!!!close client")
      client.close(client)
      test("!!!!!close client end")
--      client.state(client)
    end
}


local exeCommand = function(n,v)
  if(type(commands_do[n]) == "function") then
    commands_do[n](v)
  end
end

function send(cName,cValue)
  local cmd = "cName:" .. cName .. ",value " .. cValue
  test(cmd)
  exeCommand(cName,cValue)
end


--local sendCommands = function()
--  test("sendCommands ... ,size:" .. commands:size())
--  if(commands:size())>0 then
--    local command = commands:get(0)
--    local cName = command:getCommandName()
--    local cValue = command:getValue()
--    exeCommand(cName,cValue)
--    test("do send :" ..cName .."params" .. cValue)
--    commands:remove(0)
--  end
--end

function listen()
    test("listen......")
    test(_isConnected)
  if _isConnected == 1 then
    local message = nil
    test("lua listen==========before select=======")
    local recvt,sendt,status = socket.select({client.sock},nil,1)
    if #recvt > 0 then
      message = client.receive(client)
      test("message:" .. message)
      --test("lua client recevied msg")
      --调用解析器
      p.parse(message)
      test("client parse message")
    end
  end
end


function connect(url)
  if _isConnected == 0 then
    local serverURL = url
    local _,err = client.connect(client,url) 
   
    if err == nil then
      _isConnected = 1
      return true
    end
    return false
  else
    return true
  end
end
