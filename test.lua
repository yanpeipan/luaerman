require'client'
local cjson=require'cjson'
local inspect=require'inspect'
local message = '{"message":{"content":{"text":"\\u597d\\u559c\\u6b22\\u8fd9\\u5973\\u4e3b\\u89d2"},"type":0},"receiver":{"uid":"164553"},"sender":{"uid":"322942","loginname":"weibo_22826","sex":"1","avatar":"http:\\/\\/tp1.sinaimg.cn\\/1917435364\\/180\\/5644898103\\/1","nickname":"\\u8584\\u8377\\u6ce1\\u6ce1\\u6ce1"}}'
--message = cjson.decode(message)
--print(inspect(message))
--print(cjson.encode({['sender']='hello world', ['323']=32}))
--local charTarget = require'ChatTarget'
--local target = charTarget.new(1, 2)
--print(target:get())

local _g = init('android', '/Users/yanpeipan/IMDB', nil, nil)
debug()
print('connect server:', connectServer())
--print('disconnect:', disconnect())
--receive()
--print('connect server:', connectServer())
print('client state:', _g.client.state)

call('login', '15063343355', '295079529')
--call('login', '18600218174', '19891015')
--login('15063343355', '295079529')
--login('7eebb715b083b51a93465730c928b97d')
call('receive')
print('is online:', isOnline())

--local _g = getter()
--print(_g.currentUser.isLogin)

--call('joinGroup', 67854)
--joinGroup(67854)
--call('receive')

--call('requestGroupMemberlist', 103)
--call('receive')

--call('sendText', 67854, 2, message)
--call('sendText', 233555, '0', {'hello'})
--sendText(233555, '0', 'hello')
--sendText(233555, 0, 'test' .. os.time())
--call('sendText', 244464, '0', 'sdfsfsf')
--call('sendText', 261690, '0', {'hello'})
--call('receive')
--call('receive')
--call('receive')

--print('lastMessage:', getLastMessage(103, 2)) --返回json数据格式不对
--print('sessionList', getSessionlist())
--print('getLocalMessage', print((getLocalMessage(261690, 0, 3, 10))))
--getLocalMessage(288335, 0, 3, 10)
--print('delete session', deleteSession(233555, 0))
--print('unread message count:', getUnreadMsgcount(233555, 0))
print('unread message count by type:', getUnreadMsgcountByType(2))
--print('mark message as read:', markMessagesAsread(233555, 0))
--print(getUnreadMsgcountByType(0))
--print(markSingleMessages()) --服务器未实现
--print(markMessagesAsread(233555)) --服务器未实现
--print(getTargetDetail(233555)) --弃用

--call('leaveGroup', 1)
--call('receive')

--call('logout')
