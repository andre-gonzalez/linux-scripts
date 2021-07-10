#!/bin/sh
#Packages from arch linux repository
sudo pacman -S nvidia xorg xorg-xinit nitrogen discord spotifyd vaultwarden 

#Packages from aur
yay -S brave-bin authy obsidian


#Dwm with st and dmenu
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu

#etc.
