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
  self.db = lsqlite3.open(sqlite.path)
  setmetatable(self, {__index = sessionModel})
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
  ]=]
  return a, self.db:errmsg()
end

function sessionModel:add(uid, target, target_type, target_name)
  local sql = 'INSERT INTO session () VALUES (?, ?, ?, ?)'
  local stmt = self.db:prepare(sql)
  local errcode = self.db:errcode()
  local lastInsertId = 0
  if errcode == 0 then
    stmt:bind_values(uid, target, target_type, target_name)
    local code = stmt:step()
    lastInsertId = stmt:last_insert_rowid()
    stmt:reset()
  end
  return lastInsertId or 0, self.db:errmsg()
end

function sessionModel:delete()
end

function sessionModel:get(sender, receiver, receiver_type)
end

return m
