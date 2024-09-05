#!/bin/sh
set -e

# Variables
UUID1="453004f2-4930-42e4-897f-62ada9358b15"       # Replace with the UUID of the first partition
MOUNT_POINT1="/mnt/hd-externo/"      # Replace with the desired mount point for the first partition

UUID2="432659AB00A22BAF"      # Replace with the UUID of the second partition
MOUNT_POINT2="/mnt/ntfs-hd-externo"      # Replace with the desired mount point for the second partition

# Function to create a mount point if it does not exist
create_mount_point() {
    if [ ! -d "$1" ]; then
        echo "Creating mount point directory $1..."
        sudo mkdir -p "$1"
    fi
}

# Function to mount a device by UUID
mount_device() {
    DEVICE=$(blkid -U "$1")
    if [ -z "$DEVICE" ]; then
        echo "Error: Device with UUID=$1 not found"
        return 1
    fi
    echo "Mounting $DEVICE to $2..."
    sudo mount "$DEVICE" "$2"
}

# Function to check if a mount point is already in use
is_mounted() {
    mount | grep -q "$1"
}

# Function to check and mount a partition
check_and_mount() {
    MOUNT_POINT="$1"
    UUID="$2"

    create_mount_point "$MOUNT_POINT"

    if is_mounted "$MOUNT_POINT"; then
        echo "Device is already mounted at $MOUNT_POINT"
    else
        if mount_device "$UUID" "$MOUNT_POINT"; then
            echo "Successfully mounted UUID=$UUID to $MOUNT_POINT"
        else
            echo "Failed to mount UUID=$UUID to $MOUNT_POINT"
            exit 1
        fi
    fi
}

if [ "$1" = "mount" ]; then
	# Check and mount partitions
	check_and_mount "$MOUNT_POINT1" "$UUID1"
	check_and_mount "$MOUNT_POINT2" "$UUID2"
elif [ "$1" = "umount" ]; then
	umount /mnt/hd-externo/
	umount /mnt/ntfs-hd-externo/
fi
