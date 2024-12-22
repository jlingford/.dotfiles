# zmodload zsh/zprof # use to time zsh startup

# Boot up tmux with new terminal session
if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    exec tmux new-session -A -s ${USER} >/dev/null 2>&1
fi

# Speed up zsh start time by not loading compinit every time
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# # lf integration
# LFCD="~/.config/lf/lfcd.sh"
# if [ -f "$LFCD" ]; then
#     source "$LFCD"
# fi
#
# mmseqs2 autocompletion
# MMSEQS="/home/james/Documents/MMseqs2/util/bash-completion.sh"
# if [ -f "$MMSEQS" ]; then
#     source "$MMSEQS"
# fi
# Custom settings
# export EDITOR="nvim"
export EDITOR=editor #see ~/.dotfiles/scripts/editor for details (works with yazi)
export VISUAL="$EDITOR"
export TERM=xterm-256color
# export TERM=alacritty

# yazi integration
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# FZF
## fzf keybindings
eval "$(fzf --zsh)"

## fd integration into fzf and **<TAB> completion
# export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git"
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

## pretty fzf previews in **<TAB> completion
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"
# export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'lsd -a --tree --color=always {}'"
show_file_or_dir_preview="if [ -d {} ]; then lsd --tree --color=always --icon=always {}; else bat --color=always {}; fi"
_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)              fzf --preview 'lsd -a --tree --color=always --icon=always {}' "$@" ;;
        export|unset)    fzf --preview "eval 'echo \$' {}" "$@" ;;
        ssh)             fzf --preview 'dig {}' "$@" ;;
        *)               fzf --preview "$show_file_or_dir_preview" "$@" ;;
    esac
}
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -se c)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Neovim config changer
function ns() {
  items=("default" "Kickstart" "LazyVim" "NvChad" "AstroNvim" "QuartoNvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
# plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
# plug "wintermi/zsh-starship"
plug "esc/conda-zsh-completion"
# plug "zap-zsh/vim"
# plug "zap-zsh/fzf"
# plug "zap-zsh/exa"
plug "hlissner/zsh-autopair"
# plug "zsh-history-substring-search"
plug "Aloxaf/fzf-tab"
plug "zsh-users/zsh-history-substring-search"
plug "jeffreytse/zsh-vi-mode"  # is blocking CTRL-R mode for fzf history search.

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

# starship initialize
eval "$(starship init zsh)"


# History settings
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
HISTFILE=$HOME/.zsh_history
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Paths
export PATH="/home/james/Documents/localcolabfold/colabfold-conda/bin:$PATH"
export PATH="/home/james/.dotfiles/scripts:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/git-fuzzy/bin:$PATH"
# export PATH="$HOME/.local/share/nvim/distant.nvim/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
export PATH="$HOME/Documents/foldseek/bin/:$PATH"

# bindkey
bindkey "^[[3~" delete-char

# Aliases
# alias ls="eza"
# alias la="eza -lah --icon=always --no-user"
# alias las="eza -lah --icon=always --no-user --total-size" # la "size"
# alias lt="eza -lah --icon=always --no-user --total-size --sort=newest"
# alias ltr="eza -lah --icon=always --no-user --total-size --sort=oldest"
# alias tree="eza -lah --icon=always --no-permissions --no-user --total-size --git-ignore --tree --level 3"
# alias treedir="eza -lah --icon=always --no-permissions --no-user --total-size --git-ignore --no-time --tree -D"
# alias treeall="eza -lah --icon=always --no-permissions --no-user --total-size --git-ignore --tree"
alias ls="lsd"
alias la="lsd -la"
alias lat="lsd -la --total-size"
alias lt="lsd -lat"
alias ltr="lsd -latr"
alias tree="lsd -a --tree"
alias less="bat" #replacing less with bat
alias man="batman" #replacing man pages with bat-extras man pages "batman"
alias lg="lazygit"
# source
alias reload="source ~/.zshrc"
# lf
alias lf="lfcd"
# alias useful dir changes
alias cd="z"
alias afdir="~/Dropbox/Monash/AlphaFold"
alias alan="~/Documents/alan/alan"
alias chimerax="/home/james/Documents/chimerax-2024.03.13/bin/ChimeraX &"
alias clr="clear"
alias conf="cd ~/.config; ls"
alias share="cd ~/.local/share; ls"
alias lab="cd ~/Dropbox/Monash/Notebooks; ls"
alias doc="cd ~/Documents; ls"
alias dot="cd ~/.dotfiles; ls"
alias down="cd ~/Downloads; ls"
alias drop="cd ~/Dropbox; ls"
alias epg="cd ~/Documents/epg-blog; ls"
alias f="fzf --preview='bat --color=always {}'"
alias fv="fd --type f --hidden --exclude .git | fzf-tmux --preview='bat --color=always {}' --reverse | xargs ${EDITOR}" # fz = fzf into nvim
alias ff="fastfetch -c examples/17"
# alias c="cd $(fd --type d --hidden --exclude .git | fzf-tmux --preview='bat --color=always {}' --reverse)" # fz = fzf into nvim
alias mamba="micromamba"
function mkdircd ()
{
    mkdir -p $1 && cd $1
}
alias mkd="mkdircd"
alias mon="cd ~/Dropbox/Monash; ls"
alias rub="cd ~/Dropbox/Monash/Rubisco_project; ls"
alias ncon="cd ~/.dotfiles/nvim/.config/nvim; nvim"
alias sec="cd ~/Documents/sec_traces; ls"
alias web="cd ~/Documents/website"
# thefuck alias
eval $(thefuck --alias)
# Neovim aliases
alias v="NVIM_APPNAME=LazyVim nvim"
alias vk="NVIM_APPNAME=KickstartNvim nvim"
alias vc="NVIM_APPNAME=NvChad nvim"
alias va="NVIM_APPNAME=AstroNvim nvim"
alias vq="NVIM_APPNAME=QuartoNvim nvim"
alias vn="nvim"
alias vz="nvim ~/.zshrc"



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
export PATH=$PATH:/home/james/.pixi/bin

# zprof # use to time zsh startup
