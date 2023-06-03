#!/bin/sh

ls "$HOME"/.config/.wallpaper/*.png "$HOME"/.config/.wallpaper/*.jpg | sort -R | head -n 1 | xargs feh --bg-fill --no-fehbg
