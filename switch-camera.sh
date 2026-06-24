#!/bin/sh
# Enable or disable the internal laptop camera via a udev rule.
# Solves the problem of apps defaulting to the laptop webcam when a better
# USB camera is connected.
#
# Internal-camera USB IDs differ per machine, so the rule covers every known
# internal camera plus any device lsusb reports as "Integrated"/"Internal".
# A udev rule only fires for a device that is actually present, so listing
# several ids is harmless on any given machine.
# Usage: switch-camera.sh block|unblock|status

set -e

# Known internal cameras (vendor:product), one per machine seen so far.
KNOWN_CAMERAS="2232:1080 30c9:00f4"

UDEV_RULE="/etc/udev/rules.d/99-disable-internal-camera.rules"

# Print "vendor:product" for every internal camera: the known list plus any
# USB device whose description marks it as an integrated/internal camera.
detect_cameras() {
	{
		for id in $KNOWN_CAMERAS; do
			printf '%s\n' "$id"
		done
		lsusb 2>/dev/null | grep -iE 'integrated|internal' | grep -iE 'camera|webcam' |
			awk '{ print $6 }'
	} | grep -E '^[0-9a-fA-F]{4}:[0-9a-fA-F]{4}$' | sort -u
}

reload_udev() {
	echo "Reloading udev rules..."
	udevadm control --reload-rules
	udevadm trigger
	echo "Done."
}

block_camera() {
	cameras=$(detect_cameras)
	if [ -z "$cameras" ]; then
		printf 'error: no internal camera detected\n' >&2
		exit 1
	fi
	echo "Blocking internal camera(s):"
	{
		echo "# Disable internal laptop camera(s) by deauthorizing the device"
		for cam in $cameras; do
			vendor=${cam%:*}
			product=${cam#*:}
			echo "  $vendor:$product" >&2
			printf 'ATTR{idVendor}=="%s", ATTR{idProduct}=="%s", ATTR{authorized}="0"\n' \
				"$vendor" "$product"
		done
	} >"$UDEV_RULE"
	reload_udev
	echo "Internal camera blocked."
}

unblock_camera() {
	echo "Unblocking internal camera..."
	if [ -f "$UDEV_RULE" ]; then
		rm "$UDEV_RULE"
		reload_udev
		echo "Internal camera unblocked."
	else
		echo "No udev rule found. Internal camera was not blocked."
	fi
}

if [ "$(id -u)" -ne 0 ]; then
	echo "Please run as root or with sudo." >&2
	exit 1
fi

case "$1" in
block)
	block_camera
	;;
unblock)
	unblock_camera
	;;
status)
	if [ -f "$UDEV_RULE" ]; then
		echo "Internal camera is BLOCKED. Rule: $UDEV_RULE"
	else
		echo "Internal camera is active (no block rule)."
	fi
	;;
*)
	echo "Usage: $0 block|unblock|status" >&2
	exit 1
	;;
esac
