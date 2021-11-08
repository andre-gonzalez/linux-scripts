#!/bin/sh

# manually update pacman.conf first in the etc/pacman.conf

#update mirror list with the fastest mirrors
sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist

#unistall archo-install-scripts because it will not be necessary again
sudo pacman -R arch-install-scripts amd-ucode archinstall brltty nano

#Sync and update packages already installed and installing new software from arch linux repository
sudo pacman --noconfirm --needed -Syu $(<packages-list/packages-list.txt)

#Install Yay
cd /home/frank/.config
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

#Packages from aur
yay --noconfirm --needed -Sy $(<packages-list/aur-packages-list.txt) 

# Now we are entering .config to install and configur the programs i use
cd /home/frank/.config

#Dwm
#patches i am using: alpha_patch, alpha_focus_highlight_patch, scrollback_patch, scrollback_mouse_patch, vim_browse_patch
git clone https://github.com/Andre-gonzalez/my-dwm.git
cd my-dwm
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
cd /home/frank/.config

#slock to block the screen 
#patches i use are: capscolor and dpms
#xautolock if you want to block the screen after a specific period of time
git clone https://github.com/Andre-gonzalez/my-slock.git
cd my-slock
sudo make clean install
cd ..

#unistall unnedded dependencies
pacman -Qdt | sudo pacman -Rns

#remove cache from old packages
sudo pacman -Sc

#Copying dot files to the home directory
cp -a /home/frank/arch-setup/dotfiles/home/. /home/frank/

#Copying some config files to the etc/ directory
cp -a /home/frank/arch-setup/dotfiles/etc/. /etc/

#Moving scripts to run the directory that dmenu looks for scripts to execute
cp /home/frank/arch-setup/scripts-dmenu/. /usr/local/bin

# Enable cron in systemd
#sudo systemctl enable cronie.service --now

#bluetooth configuration
modprobe btusb
sudo systemctl start bluetooth.service
sudo systemctl enable bluetooth.service
bluetoothctl power on
bluetoothctl agent on
bluetoothctl default-agent
#making bluetooth automatically start after start a computer
#open the file below
#sudo vim /etc/bluetooth/main.conf
#Set AutoEnable=true
pulseaudio --start
# use pavucontrol to switch audio

#etc.
# To-do:
# 1.Add the scrollback support to st
# 2.Config spotifytui and spotifyd
# 4.Learn to config keyboard shortcut to run programs
# 5.Setup tmux
# 6.Learn to change the time until the screen goes dark
