#!/bin/sh

wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | doas apt-key add -
echo "deb https://dbeaver.io/debs/dbeaver-ce /" | doas tee /etc/apt/sources.list.d/dbeaver.list
doas apt update
doas apt -y install dbeaver-ce

