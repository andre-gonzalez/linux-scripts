#!/bin/sh

# change layout to abnt2
setxkbmap -layout br ,abnt2
# change esc with caps lock
setxkbmap -option caps:escape
# change numpad , to . (dot)
setxkbmap -option kpdl:dot &
