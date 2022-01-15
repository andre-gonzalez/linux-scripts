
full-install: first-config install-yay install-packages personal-configuration
	doas reboot

first-config:

update-fast-mirrors:
	doas reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist

configure-git:
	git config --global user.name "andre-gonzalez" ;\
	git config --global user.email "lopescg@gmail.com"

install-yay:
	cd $(HOME)/.config ;\
	git clone https://aur.archlinux.org/yay-git.git ;\
	cd yay-git ;\
	makepkg -si --noconfirm ;\
	cd $(HOME)

install-packages: install-pacman-packages install-yay-packages install-python-packages

install-pacman-packages:
	yes | yay -S iptables-nft
	doas pacman --noconfirm --needed -Syu - < packages-list/packages-list-pacman.txt

install-yay-packages:
	yay --noconfirm --needed -Sy - < packages-list/packages-list-aur.txt

install-python-packages:

disable-services:

enable-services:
	chsh -s /bin/fish ;\
	doas pkgfile --update ;\
	setxkbmap -layout us -variant intl ;\
	doas usermod -a -G docker $(USER) ;\
	doas usermod -a -G libvirt $(USER) ;\
	doas systemctl enable cups.service ;\
	doas systemctl enable wpa_supplicant.service ;\
	doas systemctl enable NetworkManager.service ;\
	doas systemctl enable bluetooth.service; \
	doas systemctl enable docker ;\
	doas systemctl enable bluetooth ;\
	doas systemctl enable libvirtd ;\
	doas systemctl enable sshd ;\
	doas systemctl --user enable ssh-agent.service ;\
    doas virsh net-autostart default ;\


personal-configuration: disable-services enable-services install-keyboard configure-apps

configure-apps:
