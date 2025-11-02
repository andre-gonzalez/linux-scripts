#!/bin/bash
#
# Rclone script to archive Jeff Geerling's most important data to an Amazon S3
# Glacier Deep Archive-backed bucket.
#
# Basic usage:
#   ./rclone.sh
#
# Script requires valid credentials - set up with `rclone config`.

RCLONE=/usr/bin/rclone

# Check if rclone is installed.
if ! [ -x "$(command -v $RCLONE)" ]; then
  echo 'Error: rclone is not installed.' >&2
  exit 1
fi

# Don't run if an instance of rclone is already running.
if ps -ef | grep -v grep | grep rclone ; then
  exit 0
fi

# Variables.
rclone_remote=personal
rclone_s3_bucket=backups-pessoal
bandwidth_limit=100M

# Make sure bucket exists.
# $RCLONE mkdir $rclone_remote:$rclone_s3_bucket

# List of directories to clone. MUST be absolute path, beginning with /.
declare -a dirs=(
  "/mnt/hd-externo/s3/arch-samsung/"
  "/mnt/hd-externo/s3/server/"
  "/mnt/hd-externo/s3/arch-samsung-wifi-networks/"
  "/mnt/hd-externo/s3/bitwarden/"
  "/mnt/hd-externo/s3/ente/"
)

# Copy files that do not exist in the bucket
for i in "${dirs[@]}"
do
	echo "Syncing Directory: $i"
	end_directory="$(basename "$i")"
	$RCLONE copy "$i" $rclone_remote:$rclone_s3_bucket"/$end_directory" --skip-links --ignore-existing --progress # --bwlimit $bandwidth_limit
	echo
	echo
done
