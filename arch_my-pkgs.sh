#!/bin/sh
#Packages from arch linux repository
sudo pacman -S nvidia xorg xorg-xinit nitrogen discord spotifyd vaultwarden 

#Packages from aur
yay -S brave-bin authy obsidian


#Dwm with st and dmenu
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu

#slock to block the screen 
git clone https://git.suckless.org/slock
#xautolock if you want to block the screen after a specific period of time
sudo pacman -S xautolock
#patches i use are: capscolor and dpms

#etc.
