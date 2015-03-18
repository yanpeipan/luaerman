function onLogin(code, user)
  print(code, user)
end
--处理方法中调用在java中注册的方法
--
--
return {

  onLogin = function(code, user)
    onLogin(code, user)
  end
}

