#!/bin/sh

# No --no-fehbg: feh records the image in ~/.fehbg, and
# ~/.config/autorandr/postswitch runs ~/.fehbg to draw it again after a layout
# change.
ls "$HOME"/.config/.wallpaper/*.png "$HOME"/.config/.wallpaper/*.jpg | sort -R | head -n 1 | xargs feh --bg-fill
