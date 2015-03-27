安装本地开发环境：LUA-5.1.5

```
brew tap homebrew/boneyard
cd $( brew --prefix )
git checkout 6b08bff /usr/local/Library/Formula/lua.rb
git checkout 1fed492 /usr/local/Library/Formula/luarocks.rb
brew install lua
brew install luarocks
brew install sqlite3

luarocks install lua-cjson
luarocks install coxpcall
luarocks install copas
luarocks install socket
luarocks install lua-websockets
luarocks install lua-messagepack
luarocks install luasec
luarocks install inspect
luarocks install httpclient
luarocks install lsqlite3 SQLITE_DIR=/usr/local/opt/sqlite/
```
