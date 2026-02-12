#!/bin/sh

adjust_bright () {
		hour=$(date +%H)
		minute=$(date +%M)

		if [ "$hour" -eq 20 -a "$minute" -ge 00 ]; then
				brightnessctl set 50%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 50 ]; then
				brightnessctl set 53%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 45 ]; then
				brightnessctl set 57%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 40 ]; then
				brightnessctl set 61%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 35 ]; then
				brightnessctl set 65%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 30 ]; then
				brightnessctl set 69%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 25 ]; then
				brightnessctl set 74%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 20 ]; then
				brightnessctl set 79%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 15 ]; then
				brightnessctl set 84%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 10 ]; then
				brightnessctl set 89%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 05 ]; then
				brightnessctl set 92%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 19 -a "$minute" -ge 00 ]; then
				brightnessctl set 97%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -ge 6 -a "$hour" -le 16 ]; then
				brightnessctl set 100%; kill -45 $(pidof dwmblocks)
				exit
		fi
}

adjust_bright

# 19:00 - 97%
# 19:05 - 92%
# 19:10 - 89%
# 19:15 - 84%
# 19:20 - 79%
# 19:25 - 74%
# 19:30 - 69%
# 19:35 - 65%
# 19:40 - 61%
# 19:45 - 57%
# 19:50 - 53%
# 20:00 - 50%
