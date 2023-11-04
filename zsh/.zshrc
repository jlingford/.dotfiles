# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "wintermi/zsh-starship"
plug "esc/conda-zsh-completion"
plug "zap-zsh/vim"
plug "zap-zsh/fzf"
plug "zap-zsh/exa"
plug "hlissner/zsh-autopair"
plug "zsh-history-substring-search"
plug "Aloxaf/fzf-tab"
plug "zsh-users/zsh-history-substring-search"

# Load and initialise completion system
autoload -Uz compinit
compinit

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/james/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/james/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/james/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/james/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Custom settings
export EDITOR=lvim
export VISUAL="$EDITOR"
export HISTSIZE=100000
export SAVEHIST=100000

# Aliases
alias la="ls -la"
alias nv="nvim"
alias lv="lvim"
alias lvplug="lv ~/.local/share/lunarvim/lvim/lua/lvim/plugins.lua"
alias conf="cd ~/.config"
alias alan="~/Documents/alan/alan"
alias afdir="~/Dropbox/Monash-work/AlphaFold"
alias starship="lv ~/.local/share/zap/plugins/zsh-starship/theme/starship.toml"
alias mamba="micromamba"
alias web="cd ~/Documents/website"

# Custom functions
init_pipenv () {
    echo "setting up .venv"
    python3 -m venv .venv
    source .venv/bin/activate
    echo "installing pipenv"
    python3 -m pip install pipenv
    echo "installing ipykernel"
    pipenv install ipykernel
}


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/home/james/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/james/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/james/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/james/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/james/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/james/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
