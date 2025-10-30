# zmodload zsh/zprof # use to time zsh startup

# =============================================================================

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

# =============================================================================

# set defualt applications
export EDITOR=editor #see ~/.dotfiles/scripts/editor for details (works with yazi)
export VISUAL="$EDITOR"
export TERM=xterm-256color

# =============================================================================

# keep this function early in the zshrc!
# yazi integration
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# =============================================================================

# Fzf initialize
eval "$(fzf --zsh)"
# Zoxide initialize
eval "$(zoxide init zsh)"
# starship initialize (fix from: https://github.com/starship/starship/issues/3418#issuecomment-2477375663)
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi
eval "$(starship init zsh)"
# thefuck alias
eval $(thefuck --alias)

# =============================================================================

# History settings
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export HISTFILE=$HOME/.zsh_history
export HISTDUP=erase
setopt globdots # autocompletion for hidden files and dirs
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# =============================================================================

# Paths
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/Dropbox/Monash/HydDB/plots:$PATH"
# export PATH="/home/james/Documents/localcolabfold/colabfold-conda/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
# export PATH="$HOME/.local/share/git-fuzzy/bin:$PATH"
# export PATH="$HOME/.local/share/nvim/distant.nvim/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"
# export PATH="$HOME/Documents/foldseek/bin/:$PATH"
# Docker completions
FPATH="$HOME/.docker/completions:$FPATH"

# =============================================================================

# FZF
## fd integration into fzf
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git"
# use Catppuccin colors for fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--color=border:#313244,label:#cdd6f4"
# **<TAB> changed to just <TAB> with zstyle and bindkey changes
# for vim **<TAB>
_fzf_compgen_path() {
    fd --type f --hidden --follow --exclude ".git" . "$1"
}
# for cd **<TAB>
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}
show_file_or_dir_preview="if [ -d {} ]; then lsd -a --tree --color=always --icon=always {}; else bat --color=always {}; fi"
show_dir_preview="lsd -a --tree --color=always --icon=always {}"
show_file_preview="bat --color=always {}"
# context aware fzf preview triggered by: <command> **<TAB>
_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        cd)              fzf --preview "$show_dir_preview" "$@" ;;
        v)               fzf --preview "$show_file_preview" "$@" ;;
        export|unset)    fzf --preview "eval 'echo \$' {}" "$@" ;;
        ssh)             fzf --preview 'dig {}' "$@" ;;
        *)               fzf --preview "$show_file_or_dir_preview" "$@" ;;
    esac
}
# pretty fzf previews in CTRL-T
export FZF_CTRL_T_OPTS="
    --preview '$show_file_or_dir_preview'
    --walker dir,follow,hidden
    --walker-skip .git,node_modules,target
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# pretty fzf preview in ALT-C completion
export FZF_ALT_C_OPTS="
    --preview '$show_dir_preview'
    --walker dir,follow,hidden
    --walker-skip .git,node_modules,target
    --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# fzf history search
# CTRL-/ to toggle small preview window to see the full command # CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -se c)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# for cd completion: 'ALT-C' or 'cd TAB' or 'cd **TAB' or 'cd CTRL-T'
# for vim completion: 'v CTRL-T' or 'v **TAB' or 'fv'

# =============================================================================

# set bindkeys
bindkey "^[[3~" delete-char # can now use the delete key properly
# bindkey "^L" forward-char # ctrl-l as a right-arrow substitute. NOTE: just use Ctrl-f (default and builtin)
export FZF_COMPLETION_TRIGGER='' # to disable **<TAB>, make fzf trigger on <TAB>
bindkey '^T' fzf-completion # allow fzf trigger with CTRL-T FZF without need for **TAB
bindkey '^I' $fzf_default_completion

# Aliases
source $HOME/.zsh/.zsh_aliases

# add ssh keys on startup
eval $(keychain --eval --quiet)

# completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case insensitive autocompletion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -a --tree --depth=1 --color=always --icon=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd -a --tree --depth=1 --color=always --icon=always $realpath'
setopt COMPLETE_ALIASES
zstyle ':fzf-tab:complete:v:*' fzf-preview 'bat --color=always $realpath'

# =============================================================================

# Neovim config changer
function ns() {
  items=("default" "Kickstart" "LazyVim" "NvChad" "AstroNvim" "QuartoNvim" "SciVim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# =============================================================================

# ANTIDOTE plugin manager
# first time loading it:
# source ~/.zsh/.antidote/antidote.zsh
# antidote load
# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh/.zsh_plugins
# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt
# Lazy-load antidote from its functions directory.
fpath=(~/.zsh/.antidote/functions $fpath)
autoload -Uz antidote
# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi
# Source your static plugins file.
source ${zsh_plugins}.zsh
# bug fixes to stop zsh-vi-mode conflicting with zsh-autopair and fzf-history, and history substring search
zvm_after_init_commands=(autopair-init)
ZVM_INIT_MODE=sourcing
function zvm_after_init() {
  zvm_bindkey viins "^R" fzf-history-widget
}
function zvm_before_init() {
  zvm_bindkey viins '^[[A' history-substring-search-up
  zvm_bindkey viins '^[[B' history-substring-search-down
  zvm_bindkey vicmd '^[[A' history-substring-search-up
  zvm_bindkey vicmd '^[[B' history-substring-search-down
}

# =============================================================================

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/james/.local/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/james/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# =============================================================================

# # tmux conda-inherit plugin
# # WARN: enabling this tmux pludin slows things down. must be placed after mamba init block
# if [[ -n "$TMUX" ]] then
#   export flavor='mamba' # NOTE: needs to be named 'mamba', not micromamba like in default
#   source $HOME/.tmux/plugins/tmux-conda-inherit/conda-inherit.sh
# fi

# =============================================================================

# Utility functions for zoxide.
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
# ZOXIDE

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

# Commands for zoxide. Disable these using --no-cmd.
\builtin alias z=__zoxide_z
\builtin alias zi=__zoxide_zi

# =============================================================================

# zprof # use to time zsh startup
