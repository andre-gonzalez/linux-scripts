#!/bin/sh

# Constants
HOST=$(hostname)
DISK_PATH=$1
BACKUP_DIR="$DISK_PATH/backup-$HOST"

# Function to calculate free and used space
calculate_space() {
	echo "Calculating space for $DISK_PATH..."
    FREE_SPACE=$(df "$DISK_PATH" | awk 'NR==2 {print $4}')
    USED_SPACE_HOME=$(df /home | awk 'NR==2 {print $3}')
    WILL_FIT=$((FREE_SPACE - USED_SPACE_HOME))
}

# Exclude the oldest backup until the drive can fit the home directory
make_space() {

    calculate_space "$DISK_PATH"

    while [ "$WILL_FIT" -lt 0 ]; do
			echo "Drive has $FREE_SPACE KB free, home uses $USED_SPACE_HOME KB, needs $WILL_FIT KB more."

			# Find the oldest backup file
			FILE_TO_EXCLUDE=$(ls -1 "$BACKUP_DIR" | head -n 1)

			# Check if a file was found before attempting to delete
			if [ -z "$FILE_TO_EXCLUDE" ]; then
				echo "No backups found to delete."
				exit 1
			fi

			echo "Deleting $FILE_TO_EXCLUDE"
			rm -fr "$BACKUP_DIR"/"$FILE_TO_EXCLUDE"

			# Recalculate space after deletion
			calculate_space "$DISK_PATH"
	done
}

# Backup home directory
backup() {
    DATE=$(date +%Y-%m-%d)

	# Excluded directories
    EXCLUDES="--exclude=lost+found --exclude=.cache --exclude=.config/autostart/ --exclude=.config/VirtualBox/"

    # Logging the backup operation
    echo "Backing up home directory to $BACKUP_DIR/$DATE-$HOST"

    # Build rsync command
	RSYNC_CMD="rsync -a --info=progress2 $EXCLUDES $HOME/ $BACKUP_DIR/$DATE-$HOST"

	# Perform the backup
    $RSYNC_CMD
}

# Check if the script received a parameter
if [ -z "$1" ]; then
    echo "Usage: $0 <disk_path>"
    exit 1
fi

make_space "$1"
backup "$1"
