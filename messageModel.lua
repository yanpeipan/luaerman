local lsqlite3 = require'lsqlite3'
local msgpack = require'MessagePack'
local messageModel = {}
local m = {}

m.new = function(sqlite)
  local sqlite = sqlite or {}
  local self = {}
  self.db = lsqlite3.open(sqlite.path)
  setmetatable(self, {__index = messageModel})
  return self
end

function messageModel:save(sender, receiver, receiver_type, message, time)
  local sql = 'INSERT INTO message (sender, receiver, receiver_type, message) VALUES (?, ?, ?, ?)'
  local stmt = self.db:prepare(sql)
  local errcode = self.db:errcode()
  local lastInsertId = 0
  if type(message) == 'table' then
    message = msgpack.pack(message)
  end
  if errcode == 0 then
    time = time or os.time()
    stmt:bind_values(sender, receiver, receiver_type, message)
    stmt:step()
    lastInsertId = stmt:last_insert_rowid()
    stmt:reset()
  end
  return lastInsertId or 0, self.db:errmsg()
end

function messageModel:get(sender, receiver, receiver_type)
  local sql = 'SELECT * FROM message WHERE '
  local values = {}
  if sender ~= nil then
    values.sender = sender
  end
end

return m
