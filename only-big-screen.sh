#!/bin/sh
# Switch the X11 output to the external (HDMI) screen only, disabling the
# laptop's internal panel. Output names differ between machines (eDP-1 vs eDP,
# HDMI-1 vs HDMI-A-0), so detect them at runtime instead of hardcoding.

# Internal laptop panel: eDP* or LVDS*. External screen: first connected HDMI*.
internal=$(xrandr --query | awk '/ connected/ && $1 ~ /^(eDP|LVDS)/ { print $1; exit }')
external=$(xrandr --query | awk '/ connected/ && $1 ~ /^HDMI/    { print $1; exit }')

if [ -z "$external" ]; then
	printf 'error: no HDMI output connected\n' >&2
	notify-send "only-big-screen" "No HDMI output connected" 2>/dev/null
	exit 1
fi

# Use 2560x1080@100 on the ultrawide if available, otherwise its preferred mode.
if xrandr --query | awk -v o="$external" '
	$1 == o { f = 1; next }
	/ connected/ || / disconnected/ { f = 0 }
	f && /2560x1080/ && /100/ { found = 1 }
	END { exit !found }'; then
	mode_args="--mode 2560x1080 --rate 100"
else
	mode_args="--auto"
fi

# shellcheck disable=SC2086 # mode_args is an intentional word split
xrandr --output "$external" --primary $mode_args --dpi 103 --scale 1x1
[ -n "$internal" ] && xrandr --output "$internal" --off

cdwm ultra
dwmblocks
