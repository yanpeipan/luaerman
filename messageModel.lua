local lsqlite3 = require'lsqlite3'

local new = function(sqlite)
  local sqlite = sqlite or {}
  local self = {}
  local db = lsqlite3.open(sqlite.path)

  self.save = function(self, sender, receiver, receiver_type, message, time)
    local sql = 'INSERT INTO message (sender, receiver, receiver_type, message) VALUES (?, ?, ?, ?)'
    local stmt = db:prepare(sql)
    time = time or os.time()
    stmt:bind_values(sender, receiver, receiver_type, message, time)
    stmt:step()
    stmt:reset()
  end
end

return new
