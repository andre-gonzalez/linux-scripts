#!/bin/sh

echo "Balancing /"
btrfs balance start -dusage=30 -musage=30 /
echo "Balancing /home"
btrfs balance start -dusage=30 -musage=30 /home
echo "Balancing /var/log"
btrfs balance start -dusage=30 -musage=30 /var/log
echo "Balancing /root/.local/share/Trash/files/cache/pacman/pkg"
btrfs balance start -dusage=30 -musage=30 /root/.local/share/Trash/files/cache/pacman/pkg
echo "Balancing /.snapshots"
btrfs balance start -dusage=30 -musage=30 /.snapshots
