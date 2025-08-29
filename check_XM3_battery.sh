#!/bin/sh

BAT=$(bluetoothctl info CC:98:8B:C1:5C:78 | grep 'Battery Percentage' | grep -oE '\([0-9]+\)' | grep -oE '[0-9]+')

notify-send "Battery XM3" "$BAT"%
