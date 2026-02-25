#!/bin/bash

# runs sed -i to edit the niri config file in place,
# commenting on or off the line of interest

config_path="$HOME/.dotfiles/niri/.config/niri/config.kdl"

# is_on=$(grep -Eq "^\s*off // TOUCHPADTARGET" "${config_path}")
# is_off=$(grep -Eq "^\s*// off // TOUCHPADTARGET" "${config_path}")

# if touchpad is on, turn it off
if grep -Eq "^\s*off // TOUCHPADTARGET" "${config_path}"; then
    # echo "it's on!"
    sed -i 's#off // TOUCHPADTARGET#// off // TOUCHPADTARGET#' "$config_path"
    exit 0
fi

# if touchpad is off, turn it on
if grep -Eq "^\s*// off // TOUCHPADTARGET" "${config_path}"; then
    # echo "it's off!"
    sed -i 's#// off // TOUCHPADTARGET#off // TOUCHPADTARGET#' "$config_path"
    exit 0
fi
