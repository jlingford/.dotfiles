-- LuaRocks configuration

rocks_trees = {
   { name = "user", root = home .. "/.luarocks" };
   { name = "system", root = "/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks" };
}
variables = {
   LUA_DIR = "/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks";
   LUA_BINDIR = "/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks/bin";
   LUA_VERSION = "5.1";
   LUA = "/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks/bin/lua";
}
