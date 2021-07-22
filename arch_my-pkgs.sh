#!/bin/sh
#Packages from arch linux repository
sudo pacman -S nvidia xorg xorg-xinit nitrogen discord spotifyd vaultwarden ranger github-cli picom xautolock cronie git

#Packages from aur
yay -S brave-bin authy obsidian xflux slack-desktop

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
# maybe attachbottom se eu não gostar de uma nova janela aparecer na esquerda no tiling mode


#slock to block the screen 
git clone https://github.com/Andre-gonzalez/my_slock.git
#xautolock if you want to block the screen after a specific period of time
#patches i use are: capscolor and dpms

#etc.
# To-do: Sync Gdrive, Configurar bluetooth
