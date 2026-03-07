#!/bin/sh

COMPOSITOR="picom"

if pgrep "$COMPOSITOR" &>/dev/null; then
    echo "Turning "$COMPOSITOR" OFF"
    pkill "$COMPOSITOR" &
else
    echo "Turning "$COMPOSITOR" ON"
    # xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 &
	"$COMPOSITOR" &
fi
