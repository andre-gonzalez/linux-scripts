#!/bin/sh
# manually update pacman.conf first in the etc/pacman.conf
sudo cp ~/arch_setup/pacman.conf /etc/pacman.conf
#update mirror list
sudo cp ~/arch_setup/mirrorlist /etc/pacman.d/mirrorlist 
#unistall archo-install-scripts because it will not be necessary again
sudo pacman -R arch-install-scripts amd-ucode archinstall brltty nano
#sync and update packages already installed
sudo pacman -Syu
#Packages from arch linux repository
sudo pacman -S nvidia xorg xorg-xinit xorg-xsetroot nitrogen spotifyd ranger github-cli picom xautolock cronie git  anki p7zip xbindkeys htop python-pip feh dbeaver vlc scrot unclutter bluez-tools bluez-utils make base-devel unzip

#Copying dot files to the home directory
cp ~/arch_setup/.xinitrc ~/.xinitrc
cp ~/arch_setup/.bash_profile ~/.bash_profile
cp ~/arch_setup/.bashrc ~/.bashrc
cp ~/arch_setup/.insync-git-ignore ~/.insync-git-ignore
cp ~/arch_setup/.vimrc ~/.vimrc
cp -r ~/arch_setup/.vim ~/.vim
cp ~/arch_setup/.xbindkeysrc ~/.xbindkeysrc
cp ~/arch_setup/.gitconfig ~/.gitconfig

#Install Yay
cd ~/.config
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

#Packages from aur
yay -S brave-bin authy obsidian xflux slack-desktop popcorntime-bin anki-git spotify insync vscodium-bin

# Now we are entering .config to install and configur the programs i use
cd ~/.config

#Dwm
#patches i am using: alpha_patch, alpha_focus_highlight_patch, scrollback_patch, scrollback_mouse_patch, vim_browse_patch
git clone https://github.com/Andre-gonzalez/my_dwm.git
cd my_dwm
sudo make clean install
cd ..

#st
git clone https://github.com/Andre-gonzalez/my-st.git
cd my-st
sudo make clean install
cd ..

#dmenu
git clone https://git.suckless.org/dmenu
cd dmenu
sudo make clean install
cd ..

#dwm-bar
git clone https://git.suckless.org/dwmstatus
cd dwmstatus
make
make PREFIX=/usr install
cd ..
git clone https://github.com/Andre-gonzalez/my-dwm-bar
cd my-dwm-bar
sudo make clean install
cd ~/.config

#slock to block the screen 
#patches i use are: capscolor and dpms
#xautolock if you want to block the screen after a specific period of time
git clone https://github.com/Andre-gonzalez/my_slock.git
cd my_slock
sudo make clean install
cd ..

#unistall unnedded dependencies
pacman -Qdt | sudo pacman -Rns

#remove cache from old packages
sudo pacman -Sc

#Moving the conectar-xm3-sh script to the /usr/local/bin folder so it can be executed by dmenu
cd ~/arch_setup
cp conectar-xm3.sh conectar-redmi.sh scrot-copy-to-clipboard.sh /usr/local/bin
cd /usr/local/bin
chmod +x conectar-xm3.sh conectar-redmi.sh scrot-copy-to-clipboard.sh
cd ~

# Enable cron in systemd
sudo systemctl enable cronie.service --now


#Instalar o google cloud SDK
cd ~/.config
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-356.0.0-linux-x86_64.tar.gz
tar google-cloud-sdk-356.0.0-linux-x86_64.tar.gz
rm  google-cloud-sdk-356.0.0-linux-x86_64.tar.gz
cd google-cloud-sdk
./google-cloud-sdk/install.sh


#etc.
# To-do:
#	2. dmenu bitwarden,
#	3. configurar atalhos de teclado para abrir os seguintes programas no dwm (ranger, brave e obsidian),
#	6. colocar teclas de ajuste de brilho para funcionar 
#	8. Aprender a configurar o ranger para ter preview e abrir os aquivos com os programas que eu definr
#  10. Entender porque o crontab não está funcionando
#  11. Configurar o excel no wine
#  12. Configure trash system in arch (check if does solve the insync one way deletion problem)
