#!/bin/sh
#Copy it to /usr/local/bin in order to execute iit with dmenu
scrot -s -f -e 'xclip -selection clipboard -t image/png -i $f'

