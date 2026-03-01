#!/bin/bash

# runs sed -i to edit the niri config file in place,
# commenting on or off the line of interest

config_path="$HOME/.dotfiles/niri/.config/niri/config.kdl"

# is_on=$(grep -Eq "^\s*off // TOUCHPADTARGET" "${config_path}")
# is_off=$(grep -Eq "^\s*// off // TOUCHPADTARGET" "${config_path}")

options "caps:swapescape" // CAPSSWAPTARGET

# if caps is caps, swap with escape
if grep -Eq "^\s*// options \"caps:swapescape\" // CAPSSWAPTARGET" "${config_path}"; then
    sed -i 's#// options "caps:swapescape" // CAPSSWAPTARGET#options "caps:swapescape" // CAPSSWAPTARGET#' "$config_path"
    exit 0
fi

# if caps is escape, swap it back
if grep -Eq "^\s*options \"caps:swapescape\" // CAPSSWAPTARGET" "${config_path}"; then
    sed -i 's#options "caps:swapescape" // CAPSSWAPTARGET#// options "caps:swapescape" // CAPSSWAPTARGET#' "$config_path"
    exit 0
fi
