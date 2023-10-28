#!/bin/bash

mouse_name="Kensington Expert Wireless TB Mouse"

check=$(xinput | grep "$mouse_name")

if [[ ! -z "$check" ]]; then
	mouse_id=$(xinput | grep "$mouse_name" | sed 's/^.*id=\([0-9]*\)[ \t].*$/\1/')
	# allow scrolling by holding middle mouse button and using the ball to scroll ( really smooth and fast ).
	xinput set-prop $mouse_id "libinput Scroll Method Enabled" 0, 0, 1
	# allow the remmaped middle mouse to be used for middle mouse scroll
	xinput set-prop $mouse_id "libinput Button Scrolling Button" 3
fi
