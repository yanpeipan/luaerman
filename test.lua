require'client'

--local charTarget = require'ChatTarget'
--local target = charTarget.new(1, 2)
--print(target:get())

init('android', '/Users/yan/IMDB', nil, nil)
debug()
print('connect server:', connectServer())

--call('login', '18600218174', '19891015')
--call('receive')
call('login', '15063343355', '295079529')
call('receive')

local _g = getter()
print(_g.currentUser.isLogin)

call('joinGroup', 103)
call('receive')

--call('requestGroupMemberlist', 103)
--call('receive')

call('sendText', 103, 2, {'hello'})
--call('sendText', 233555, 0, {'hello'})
call('receive')

--print(getLastMessage(103, 2)) --返回json数据格式不对
print(getSessionlist())
--deleteSession()
--print(getUnreadMsgcount(1, 0))
--print(getUnreadMsgcountByType(0))
--print(markSingleMessages()) --服务器未实现
--print(markMessagesAsread(233555)) --服务器未实现
--print(getTargetDetail(233555)) --弃用

--call('leaveGroup', 1)
--call('receive')

--call('logout')
