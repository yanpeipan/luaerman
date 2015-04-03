local lsqlite3 = require'lsqlite3'
local msgpack = require'MessagePack'
local messageModel = {}
local m = {}

m.new = function(sqlite)
  local sqlite = sqlite or {}
  local self = {}
  self.status = {
    read = 2,
    unread = 1
  }
  self.db = lsqlite3.open(sqlite.path)
  setmetatable(self, {__index = messageModel})
  return self
end

function messageModel:init()
  local a=self.db:exec[=[
  CREATE TABLE IF NOT EXISTS `message` ( `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `sender` INTEGER NOT NULL,
  `receiver` INTEGER NOT NULL,
  `receiver_type` INTEGER NOT NULL,
  `message` TEXT NOT NULL,
  `time` TEXT DEFAULT CURRENT_TIMESTAMP
  );
  ]=]
  return a, self.db:errmsg()
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
    local code = stmt:step()
    lastInsertId = stmt:last_insert_rowid()
    stmt:reset()
  end
  return lastInsertId or 0, self.db:errmsg()
end

function messageModel:get(sender, receiver, receiver_type)
  local sql = 'SELECT * FROM message WHERE '
  local getNamedValues = {}
  local values = {
    sender = sender,
    receiver = receiver,
    receiver_type = receiver_type
  }
  local conditions = {}
  local bindValues = {}
  for k,v in pairs(values) do
    if v ~= nil then
      table.insert(conditions, k .. '=?')
      table.insert(bindValues, v)
    end
  end
  sql = sql .. table.concat(conditions, ',')
  local stmt = self.db:prepare(sql)
  local errcode = self.db:errcode()
  if errcode == 0 then
    stmt:bind_values(unpack(bindValues))
    local code = stmt:step()
    if code == 101 then
      stmt:reset()
    else
      getNamedValues = stmt:get_named_values()
    end
  end
  return getNamedValues or {}, self.db:errmsg()
end

function messageModel:delete(sender, receiver, receiver_type)
  local sql = 'DELETE FROM message where '
  local values = {
    sender = sender,
    receiver = receiver,
    receiver_type = receiver_type
  }
  local conditions = {}
  local bindValues = {}
  local columns = 0
  for k, v in pairs(values) do
    if v ~= nil then
      table.insert(conditions, k .. '=?')
      table.insert(bindValues, v)
    end
  end
  sql = sql .. table.concat(conditions, ',')
  local stmt = self.db:prepare(sql)
  local errcode = self.db:errcode()
  if errcode == 0 then
    stmt:bind_values(unpack(bindValues))
    stmt:step()
    column = stmt:columns()
    stmt:reset()
  end
  return columns or 0, self.db:errmsg()
end

return m
