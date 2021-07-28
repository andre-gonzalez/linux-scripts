#!/bin/sh
#sync and update packages already installed
sudo pacman -Syu
#Packages from arch linux repository
sudo pacman -S nvidia xorg xorg-xinit nitrogen discord spotifyd ranger github-cli picom xautolock cronie git dbeaver anki p7zip xbindkeys

#Packages from aur
yay -S brave-bin authy obsidian xflux slack-desktop popcorntime-bin grive

cd .config
#Dwm with st and dmenu
git clone https://github.com/Andre-gonzalez/my_dwm.git
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu
gh repo clone Andre-gonzalez/my-dwm-bar
git clone git://git.suckless.org/dwmstatus
cd dwmstatus
make
make PREFIX=/usr install

#alpha_patch, alpha_focus_highlight_patch, scrollback_patch, scrollback_mouse_patch, vim_browse_patch
# maybe attachbottom se eu nÃ£o gostar de uma nova janela aparecer na esquerda no tiling mode


#slock to block the screen 
git clone https://github.com/Andre-gonzalez/my_slock.git
#xautolock if you want to block the screen after a specific period of time
#patches i use are: capscolor and dpms

#Anki download
https://github.com/ankitects/anki/releases/download/2.1.44/anki-2.1.44-linux.tar.bz2
#After installation do the following:
#cd anki-2.1.44-linux.tar.bz2
#sudo ./install.sh

#unistall unnedded dependencies
pacman -Qdt | sudo pacman -Rns

#remove cache from old packages
sudo pacman -Sc

#editar o arquivo .bash_profile para adicionar a linha do startx

#etc.
# To-do:
# 	1. Sync Gdrive, -- doing, testing Vgrive
#	2. dmenu bitwarden,
#	3. configurar atalhos de teclado para abrir os seguintes programas no dwm (ranger, brave e obsidian),
#	6. colocar teclas de ajuste de brilho para funcionar 
