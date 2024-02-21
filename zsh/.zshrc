# Boot up tmux with new terminal session
if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    exec tmux new-session -A -s ${USER} >/dev/null 2>&1
fi

# lf integration
LFCD="~/.config/lf/lfcd.sh"
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi

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
#
# Zoxide initialize
eval "$(zoxide init zsh)"

# Custom settings
export EDITOR=nvim
export VISUAL="$EDITOR"
export HISTSIZE=100000
export SAVEHIST=100000
export TERM=xterm-256color
export PATH="/home/james/Documents/localcolabfold/colabfold-conda/bin:$PATH"

# Aliases
alias ls="eza"
alias la="eza -lah --icons=always --no-user --total-size"
alias lt="eza -lah --icons=always --no-user --total-size --sort=newest"
alias ltr="eza -lah --icons=always --no-user --total-size --sort=oldest"
alias tree="eza -lah --icons=always --no-permissions --no-user --total-size --git-ignore --tree --level 3"
alias treedir="eza -lah --icons=always --no-permissions --no-user --total-size --git-ignore --no-time --tree -D"
alias treeall="eza -lah --icons=always --no-permissions --no-user --total-size --git-ignore --tree"
# source
alias reload="source ~/.zshrc; source ~/.vimrc"
# lf
alias lf="lfcd"
# alias z="zoxide"
alias afdir="~/Dropbox/Monash-work/AlphaFold"
alias alan="~/Documents/alan/alan"
alias clr="clear"
alias conf="cd ~/.config; ls"
alias doc="cd ~/Documents; ls"
alias dot="cd ~/.dotfiles; ls"
alias down="cd ~/Downloads; ls"
alias drop="cd ~/Dropbox; ls"
alias epg="cd ~/Documents/epg-blog; ls"
alias f="fzf"
alias lv="lvim"
alias lvplug="lv ~/.local/share/lunarvim/lvim/lua/lvim/plugins.lua"
alias mamba="micromamba"
alias mon="cd ~/Dropbox/Monash-work; ls"
alias monr="cd ~/Dropbox/Monash-work/Rubisco_project; ls"
alias ncon="cd ~/.dotfiles/nvim/.config/nvim; nvim"
alias nv="nvim"
alias nz="nvim ~/.zshrc"
alias ra="ranger"
alias starship="lv ~/.local/share/zap/plugins/zsh-starship/theme/starship.toml"
alias v="vim"
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

# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}

# Initialize hook.
# shellcheck disable=SC2154
if [[ ${precmd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] && [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]]; then
    chpwd_functions+=(__zoxide_hook)
fi

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
    # shellcheck disable=SC2199
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$@[-1]" == "${__zoxide_z_prefix}"?* ]]; then
        # shellcheck disable=SC2124
        \builtin local result="${@[-1]}"
        __zoxide_cd "${result:${#__zoxide_z_prefix}}"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" &&
            __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# Completions.
if [[ -o zle ]]; then
    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            _files -/
        elif [[ "${words[-1]}" == '' ]] && [[ "${words[-2]}" != "${__zoxide_z_prefix}"?* ]]; then
            \builtin local result
            # shellcheck disable=SC2086,SC2312
            if result="$(\command zoxide query --exclude "$(__zoxide_pwd)" --interactive -- ${words[2,-1]})"; then
                result="${__zoxide_z_prefix}${result}"
                # shellcheck disable=SC2296
                compadd -Q "${(q-)result}"
            fi
            \builtin printf '\e[5n'
        fi
        return 0
    }

    \builtin bindkey '\e[0n' 'reset-prompt'
    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete __zoxide_z
fi

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

\builtin alias z=__zoxide_z
\builtin alias zi=__zoxide_zi
