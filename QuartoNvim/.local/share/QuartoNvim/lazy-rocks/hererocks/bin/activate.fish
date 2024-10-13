if functions -q deactivate-lua
    deactivate-lua
end

function deactivate-lua
    if test -x '/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks/bin/lua'
        eval ('/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks/bin/lua' '/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks/bin/get_deactivated_path.lua' --fish)
    end

    functions -e deactivate-lua
end

set -gx PATH '/home/james/.local/share/QuartoNvim/lazy-rocks/hererocks/bin' $PATH
