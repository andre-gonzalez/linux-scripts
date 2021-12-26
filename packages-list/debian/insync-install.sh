#!/bin/sh

doas apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ACCAF35C
deb http://apt.insync.io/debian bullseye non-free contrib
doas apt-get update
doas apt-get install insync
