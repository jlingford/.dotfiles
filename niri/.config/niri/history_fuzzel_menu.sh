#!/usr/bin/env bash

# based on...
# fc -ln 0 | fuzzel --dmenu | wl-copy

# NOTE: can't use fc or history commands, need to read directly from zsh_history for it to work with niri
tac ~/.zsh_history | sed 's/^: [0-9]*:[0-9]*;//' | fuzzel --dmenu | wl-copy

sleep 0.1

# Get the focused window's app-id via niri
app_id=$(niri msg -j focused-window | jq -r '.app_id // empty')

# Ctrl-shift-v for a terminal, Ctrl-v for everything else
case "$app_id" in
kitty | foot | Alacritty | org.wezfurlong.wezterm)
    wtype -M ctrl -M shift -k v -m shift -m ctrl
    ;;
*)
    wtype -M ctrl -k v -m ctrl
    ;;
esac
