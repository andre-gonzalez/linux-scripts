#!/bin/sh

# First do a doas su to enter root user in order to install doas nvim and git
# doas apt install doas neovim git

#Installing the apps i use
doas apt-get install $(cat packages-list/debian/packages-debian.txt)

/bin/bash /home/frank/arch-setup/packages-list/debian/insync-install.sh
/bin/bash /home/frank/arch-setup/packages-list/debian/brave-install.sh
#/bin/bash /home/frank/arch-setup/packages-list/debian/dbeaver-install.sh

# Now we are entering .config to install and configur the programs i use
mkdir /home/frank/.config
cd /home/frank/.config

#Dwm
#patches i am using: alpha_patch, alpha_focus_highlight_patch, scrollback_patch, scrollback_mouse_patch, vim_browse_patch
git clone https://github.com/Andre-gonzalez/my-dwm.git
cd my-dwm
doas make clean install
cd ..

#st
git clone https://github.com/Andre-gonzalez/my-st.git
cd my-st
doas make clean install
cd ..

#dmenu
git clone https://git.suckless.org/dmenu
cd dmenu
doas make clean install
cd ..

#dwm-bar
git clone https://git.suckless.org/dwmstatus
cd dwmstatus
make
make PREFIX=/usr install
cd ..
git clone https://github.com/Andre-gonzalez/my-dwm-bar
cd my-dwm-bar
doas make clean install
cd /home/frank/.config

#slock to block the screen
#patches i use are: capscolor and dpms
#xautolock if you want to block the screen after a specific period of time
git clone https://github.com/Andre-gonzalez/my-slock.git
cd my-slock
doas make clean install
cd ..

#Copying dot files to the home directory
cp -a /home/frank/arch-setup/dotfiles/home/. /home/frank/

#Copying some config files to the etc/ directory
cp -a /home/frank/arch-setup/dotfiles/etc/. /etc/

#Moving scripts to run the directory that dmenu looks for scripts to execute
cp /home/frank/arch-setup/scripts-dmenu/. /usr/local/bin

# Enable cron in systemd
#doas systemctl enable cronie.service --now

#bluetooth configuration
modprobe btusb
doas systemctl start bluetooth.service
doas systemctl enable bluetooth.service
bluetoothctl power on
bluetoothctl agent on
bluetoothctl default-agent
#making bluetooth automatically start after start a computer
#open the file below
#doas vim /etc/bluetooth/main.conf
#Set AutoEnable=true
pulseaudio --start
# use pavucontrol to switch audio

# run doas nano /etc/default/grub
# update GRUB_TIMEOUT=1
# and GRUB_TIMEOUT_STYLE=hidden
# then run grub-mkconfig -o /boot/grub/grub.cfg

# Configuring virtualization using KVM QEMU
usermod --append --groups libvirt `whoami`
