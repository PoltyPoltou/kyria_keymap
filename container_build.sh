#!/bin/bash
cd /workspaces/zmk/app
if [[ "p" == ${1-""} ]] ; then
    west build -p -d build/right -b nice_nano_v2 -- -DZMK_CONFIG="/workspaces/zmk/kyria_keymap/config" -DSHIELD=kyria_rev3_right
    west build -p -d build/left -b nice_nano_v2 -- -DZMK_CONFIG="/workspaces/zmk/kyria_keymap/config" -DSHIELD=kyria_rev3_left
else
    west build -d build/right
    west build -d build/left
fi