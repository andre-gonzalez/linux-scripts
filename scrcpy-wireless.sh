!/bin/sh

DEVICE_IP="192.168.0.2:5555"
adb connect "$DEVICE_IP:5555" && scrcpy --serial "$DEVICE_IP:5555"
