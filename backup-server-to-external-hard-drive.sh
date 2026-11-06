backup() {
    DATE=$(date +%Y-%m-%d)

	# Excluded directories
    EXCLUDES="--exclude=lost+found --exclude=.cache --exclude=.config/autostart/ --exclude=.config/VirtualBox/ --exclude=.local/share/Trash --exclude=videos/ --exclude=.local/share/Steam --exclude=.local/share/qutebrowser --exclude=.local/share/cargo --exclude=.local/share/ULWGL --exclude=.local/share/snyk-ls --exclude=.config/BraveSoftware --exclude=.config/Slack --exclude=.config/heroic --exclude=.config/EmuDeck --exclude=.config/wall-d/install"

	# Directories to backup
	BACKUP_DIRECTORY="/home/frank"
	DOCKER_FILES="/var/lib/docker"

	# Backup destination
	BACKUP_DESTINATION="/mnt/hd-externo/server"
	MACHINE="servarr"

    # Logging the backup operation
    echo "Backing up home directory to $BACKUP_DESTINATION/$DATE-$MACHINE/"

    # Build rsync command
    RSYNC_CMD="sudo rsync -avz --info=progress2 $EXCLUDES -e ssh -p 1050 frank@$MACHINE:$BACKUP_DIRECTORY $BACKUP_DESTINATION/$DATE-$MACHINE/"

	# Perform the backup
    $RSYNC_CMD
}

backup
