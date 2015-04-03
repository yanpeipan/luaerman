require'client'
local sqlite=require'lsqlite3'
init('android', '/Users/yan/IMDB')
connectServer()

call('login', '18600218174', '19891015')
call('receive')
call('receive')
call('receive')
call('receive')

--call('joinGroup', 103)
--call('receive')

--call('requestGroupMemberlist', 1)
--call('receive')

call('sendText', 103, 2, {'hello'})
call('receive')

print(getLastMessage(103, 2))

--print(getSessionlist())
--
--deleteSession()

--call('leaveGroup', 1)
--call('receive')

--print(getUnreadMsgcount(1, 0))
--print(getTargetDetail(233555))
--print(markMessagesAsread(233555))
--call('logout')

print(math.floor(103/100, 0))
