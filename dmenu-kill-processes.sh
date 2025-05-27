#!/bin/sh

ps -u $USER --no-headers -o pid,comm | dmenu -W 250 -l 10 -p Kill: | awk '{print $1}' | xargs -r kill -15
