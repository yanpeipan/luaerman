local lsqlite3 = require'lsqlite3'
local msgpack = require'MessagePack'
local sessionModel = {}
local m = {}

m.new = function(sqlite)
  local sqlite = sqlite or {}
  local self = {}
  self.status = {
    read = 2,
    unread = 1
  }
  self.db = assert(lsqlite3.open(sqlite.path))
  setmetatable(self, {__index = sessionModel})
  self:init()
  return self
end

function sessionModel:init()
  local a=self.db:exec[=[
  CREATE TABLE IF NOT EXISTS `session` (
  `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  `uid` INTEGER NOT NULL,
  `target` INTEGER NOT NULL,
  `target_type` INTEGER NOT NULL,
  `target_name` TEXT NOT NULL,
  `time` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
  );
  CREATE UNIQUE INDEX `unique_session` ON `session` (`uid` ,`target` ,`target_type`)
  ]=]
  return a, self.db:errmsg()
end

function sessionModel:add(uid, target, target_type, target_name)
  local sql = 'INSERT OR REPLACE INTO session VALUES (?, ?, ?, ?, ?, datetime())'
  local stmt = self.db:prepare(sql)
  local errcode = self.db:errcode()
  local lastInsertId = 0
  target_name = target_name or ''
  if errcode == 0 then
    stmt:bind_values(nil, uid, target, target_type, target_name)
    local code = stmt:step()
    lastInsertId = stmt:last_insert_rowid()
    stmt:reset()
  end
  return lastInsertId or 0, self.db:errmsg()
end

function sessionModel:delete(uid, target, target_type)
  local sql = 'DELETE FROM session where '
  local values = {
    uid = uid,
    target = target,
    target_type = target_type
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

function sessionModel:get(uid, sender, receiver, receiver_type)
  local sql = 'SELECT * FROM session WHERE '
  local getNamedValues = {}
  local values = {
    uid = uid,
    sender = sender,
    receiver = receiver,
    reciever_type = receiver_type
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

return m
