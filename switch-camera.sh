#!/bin/bash

# Script to enable or disable internal laptop camera via udev rule
# It aims to solve a personal problem i have of apps opening by default my
# laptop webcam when I have a better one on USB
# Usage: ./toggle_internal_camera.sh block|unblock

set -e

# Replace with actual vendor/product IDs of your internal camera
ID_VENDOR="2232"
ID_PRODUCT="1080"

# Path to the udev rule
UDEV_RULE="/etc/udev/rules.d/99-disable-internal-camera.rules"

# Function to reload udev
reload_udev() {
    echo "Reloading udev rules..."
    sudo udevadm control --reload-rules
    sudo udevadm trigger
    echo "Done."
}

# Function to block internal camera
block_camera() {
    echo "Blocking internal camera..."
    sudo bash -c "cat > $UDEV_RULE" <<EOF
# Disable internal laptop camera by ignoring the device
ATTR{idVendor}==\"$ID_VENDOR\", ATTR{idProduct}==\"$ID_PRODUCT\", ATTR{authorized}=\"0\"
EOF
    reload_udev
    echo "Internal camera blocked."
}

# Function to unblock internal camera
unblock_camera() {
    echo "Unblocking internal camera..."
    if [ -f "$UDEV_RULE" ]; then
        sudo rm "$UDEV_RULE"
        reload_udev
        echo "Internal camera unblocked."
    else
        echo "No udev rule found. Internal camera was not blocked."
    fi
}

# Main logic
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo."
    exit 1
fi

case "$1" in
    block)
        block_camera
        ;;
    unblock)
        unblock_camera
        ;;
    *)
        echo "Usage: $0 block|unblock"
        exit 1
        ;;
esac
