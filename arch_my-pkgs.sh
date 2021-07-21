#!/bin/sh
#Packages from arch linux repository
sudo pacman -S nvidia xorg xorg-xinit nitrogen discord spotifyd vaultwarden ranger github-cli picom

#Packages from aur
yay -S brave-bin authy obsidian 


#Dwm with st and dmenu
git clone https://github.com/Andre-gonzalez/my_dwm.git
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu

# MoveStack, fakefullscreen, noborder, pertag
# maybe attachbottom se eu não gostar de uma nova janela aparecer na esquerda no tiling mode


#slock to block the screen 
git clone https://github.com/bakkeby/slock-flexipatch.git
#xautolock if you want to block the screen after a specific period of time
sudo pacman -S xautolock
#patches i use are: capscolor and dpms

#etc.
# To-do: Sync Gdrive, Configurar bluetooth
