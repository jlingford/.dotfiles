#!/usr/bin/env bash

# based on...
# cliphist list | sort -k1,1g | cut -f2- | fuzzel --dmenu | cliphist decode | wl-copy

# select cliphist id from fuzzel menu, pass to wl-copy
selected=$(cliphist list | fuzzel --dmenu)
[ -n "$selected" ] || exit 0
echo "$selected" | wl-copy

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
