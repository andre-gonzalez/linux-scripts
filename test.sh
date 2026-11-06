#!/bin/sh

noisetorch /usr/bin/sh -c '
	for i in $(seq 1 30); do
		src=$(pactl list sources short 2>/dev/null | awk "/usb-C-Media/{print \$2; exit}")
		if [ -n "$src" ]; then
			exec noisetorch -i "$src"
		fi
		sleep 1
	done
'
