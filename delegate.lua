--处理方法中调用在java中注册的方法
--
--
return {

  onLogin = function(code, user)
  end,

  onLogout = function(code, user)
  end,

  onJoinGroup = function(code, group)
  end,

  onLeaveGroup = function(code, group)
  end,

  onUserJoinGroup = function(group, user)
  end,

  onUserLeaveGroup = function(group, user)
  end,

  onBeat = function()
  end,

  onGetGroupMemberList = function(code, group, page, curPageMemberList, allMemberList)
  end,

  onReceiveMessage = function(code, message)
  end,

  onReconnecting = function(code, user)
  end,

  onGetProfile = function(code, user)
  end,

  onSendMessage = function(code, message)
  end,
}

