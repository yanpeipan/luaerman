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
  self:init()
  return self
end

--init
--
function messageModel:init()
  local a=self.db:exec[=[
  CREATE TABLE IF NOT EXISTS `message` (
  `dbID` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `id` INTEGER NOT NULL DEFAULT 0,
  `sender` INTEGER NOT NULL,
  `sender_type` INTEGER NOT NULL DEFAULT 0,
  `receiver` INTEGER NOT NULL,
  `receiver_type` INTEGER NOT NULL,
  `text` TEXT NOT NULL,
  `status` INTEGER NOT NULL,
  `date` INTEGER NOT NULL DEFAULT CURRENT_TIMESTAMP
  );
  ]=]
  return a, self.db:errmsg()
end

--add
--
function messageModel:add(id, sender, receiver, receiver_type, text, status)
  local sql = 'INSERT INTO message (id, sender, receiver, receiver_type, text, status) VALUES (?, ?, ?, ?)'
  local stmt = self.db:prepare(sql)
  local errcode = self.db:errcode()
  local lastInsertId = 0
  if errcode == 0 then
    stmt:bind_values(id, sender, receiver, receiver_type, text, status)
    local code = stmt:step()
    lastInsertId = stmt:last_insert_rowid()
    stmt:reset()
  end
  return lastInsertId or 0, self.db:errmsg()
end

function messageModel:get(sender, receiver, receiver_type)
  local sql = 'SELECT *  FROM message WHERE '
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
  sql = sql .. table.concat(conditions, ',') .. ' ORDER BY date DESC'
  local stmt = self.db:prepare(sql)
  local errcode = self.db:errcode()
  if errcode == 0 then
    stmt:bind_values(unpack(bindValues))
    for row in stmt:nrows() do
      local getNamedValues = stmt:get_named_values()
      table.insert(getNamedValues, getNamedValues)
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

function messageModel:markMessagesAsread()
end

return m
