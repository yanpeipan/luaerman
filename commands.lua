--指令集
--
--
--local commands = commandList
local commands = {

  ["LOGIN"] = function(value, ...)
    local msg = {1007, value['usr'], value['psw']}
    send(msg)
  end,

}

return commands
