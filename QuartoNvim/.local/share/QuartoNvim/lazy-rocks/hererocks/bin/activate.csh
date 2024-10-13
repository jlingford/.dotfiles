which deactivate-lua >&/dev/null && deactivate-lua

alias deactivate-lua 'if ( -x '\''/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks/bin/lua'\'' ) then; setenv PATH `'\''/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks/bin/lua'\'' '\''/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks/bin/get_deactivated_path.lua'\''`; rehash; endif; unalias deactivate-lua'

setenv PATH '/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks/bin':"$PATH"
rehash
