#!/bin/sh

ask () {
		answer="$( echo "No\nYes" | dmenu -i -p "$1" )"
}

ask "$1" "$2"

case $answer in
		"Yes")
				$2
		;;
esac
