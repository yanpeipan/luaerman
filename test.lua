require'client'
local sqlite=require'lsqlite3'
init('android')
connectServer()

--local db=sqlite.open('/Users/yan/IMDB')
-- {"user":{"nickname":"天才少年","uid":"233555","name":"18600218174","icon":"http:\/\/avatar-img.b0.upaiyun.com\/imgface\/origin\/2014-12\/c06f44cdea5f94829f441493f4b3089f.jpg!180x180"},"code":0}
--
--local a=db:exec[=[
--CREATE TABLE `user` IF NOT EXISTS(
--`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
--`nickname` TEXT NOT NULL,
--`name` TEXT NOT NULL,
--`icon` TEXT NOT NULL,
--`time` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
--);
--CREATE TABLE `message` IF NOT EXISTS(
--`id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
--`sender` INTEGER NOT NULL,
--`receiver` INTEGER NOT NULL,
--`receiver_type` INTEGER NOT NULL,
--`message` TEXT NOT NULL,
--`time` TEXT DEFAULT CURRENT_TIMESTAMP
--);
--CREATE TABLE `session` IF NOT EXISTS(
--`id` INTEGER NOT NULL PRIMARY KEY AUTOINCRE
--`target` INTEGER NOT NULL,
--`time` INTEGER NOT NULL
--);
--]=]

call('login', '18600218174', '19891015')
call('receive')
--print(getter('user'))

call('joinGroup', 103)
call('receive')
--call('requestGroupMemberlist', 1)
--call('receive')

print(getSessionlist())
call('sendText', 1, 3, {'hello'})
call('receive')
print(getSessionlist())
deleteSession()
--call('leaveGroup', 1)
--call('receive')
--call('receive')
--call('receive')
--
--call('receive')
--call('logout')

--
--
--print(getUnreadMsgcount(1, 0))
--print(getTargetDetail(233555))
--print(markMessagesAsread(233555))
--
