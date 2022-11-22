#!/bin/sh

adjust_bright () {
		hour=$(date +%H)
		minute=$(date +%M)

		if [ "$hour" -eq 18 -a "$minute" -ge 30 ]; then
				brightnessctl set 50%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 18 -a "$minute" -ge 20 ]; then
				brightnessctl set 53%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 18 -a "$minute" -ge 15 ]; then
				brightnessctl set 57%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 18 -a "$minute" -ge 10 ]; then
				brightnessctl set 61%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 18 -a "$minute" -ge 05 ]; then
				brightnessctl set 65%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 18 -a "$minute" -ge 00 ]; then
				brightnessctl set 69%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 17 -a "$minute" -ge 55 ]; then
				brightnessctl set 74%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 17 -a "$minute" -ge 50 ]; then
				brightnessctl set 79%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 17 -a "$minute" -ge 45 ]; then
				brightnessctl set 84%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 17 -a "$minute" -ge 40 ]; then
				brightnessctl set 89%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 17 -a "$minute" -ge 35 ]; then
				brightnessctl set 92%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -eq 17 -a "$minute" -ge 30 ]; then
				brightnessctl set 97%; kill -45 $(pidof dwmblocks)
				exit
		elif [ "$hour" -ge 6 -a "$hour" -le 16 ]; then
				brightnessctl set 100%; kill -45 $(pidof dwmblocks)
				exit
		fi
}

adjust_bright

# 17:30 - 97%
# 17:35 - 92%
# 17:40 - 89%
# 17:45 - 84%
# 17:50 - 79%
# 17:55 - 74%
# 18:00 - 69%
# 18:05 - 65%
# 18:10 - 61%
# 18:15 - 57%
# 18:20 - 53%
# 18:30 - 50%
