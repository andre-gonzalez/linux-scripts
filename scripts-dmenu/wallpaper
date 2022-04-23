#!/bin/sh
ask () {
		answer="$(ls "$HOME"/.config/.wallpaper | dmenu -i -p "$1" )"
}

ask

feh --bg-fill "$HOME"/.config/.wallpaper/"$answer"
