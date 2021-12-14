#!/bin/sh

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
deb http://apt.insync.io/debian bullseye non-free contrib
sudo apt-get update
sudo apt-get install insync
