#!/bin/sh

# manually update pacman.conf first in the etc/pacman.conf

#update mirror list with the fastest mirrors
sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist

#unistall archo-install-scripts because it will not be necessary again
sudo pacman -R arch-install-scripts amd-ucode archinstall brltty nano

#Sync and update packages already installed and installing new software from arch linux repository
sudo pacman --noconfirm --needed -Syu $(cut -d\| -f2 packages-list/packages-list.md | tail -n +3 | grep -P '\S')

#Install Yay
cd $HOME/.config
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si

#Packages from aur
yay --noconfirm --needed -Sy $(cut -d\| -f4 packages-list/packages-list.md | tail -n +3 | grep -P '\S')

# Now we are entering .config to install and configur the programs i use
cd $HOME/.config

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

#dwmblocks
git clone https://git.suckless.org/dwmstatus
cd dwmstatus
make
make PREFIX=/usr install
cd ..
git clone https://github.com/Andre-gonzalez/my-dwmblocks
cd my-dwmblocks
sudo make clean install
ln -s $HOME/.config/my-dwmblocks/bar-functions/* /usr/local/bin/
cd $HOME/.config

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
cp -a $HOME/arch-setup/dotfiles/home/. $HOME/

#Copying some config files to the etc/ directory
cp -a $HOME/arch-setup/dotfiles/etc/. /etc/

#Creating symbolik link to my scripts folder
ln -s $HOME/gdrive-pessoal/pessoal/programa????o/arch-setup/scripts-dmenu/* /usr/local/bin/

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

# run doas nano /etc/default/grub
# update GRUB_TIMEOUT=1
# and GRUB_TIMEOUT_STYLE=hidden
# then run grub-mkconfig -o /boot/grub/grub.cfg

# Configuring virtualization using KVM QEMU
usermod -a -G libvirt $(whoami)
systemctl start libvirtd
systemctl enable libvirtd


#etc.
# To-do:
# 1. Move enviroment configuration to ansible
# 2. Create a makefile to setup the installation
# 3. Create a script that automatically changes dwm and st between TV and laptop mode
# 4. Configure a way to use dmenu for opening directories using fzf
# 5. Configure notification system for when the computer battery is getting to low
# 6. Change Super+shift+v to actually paste what i have just selected
# 7. Move my scripts from /usr/local/bin to $HOME/.local/bin so they can be specific to only my user and add them to my dotfiles repo
