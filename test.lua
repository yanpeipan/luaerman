require'client'
init('android')
connectServer()

call('login', '18600218174', '19891015')
call('receive')

call('joinGroup', 1)
call('receive')

call('sendText', 1, 3, 'hello')
call('receive')
--call('leaveGroup', 1)
--
--call('receive')
--call('logout')
