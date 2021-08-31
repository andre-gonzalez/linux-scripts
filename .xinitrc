#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#Keybinds for audio and backlight
xbindkeys

# DWM Status
/home/frank/.config/dwm-bar/dwm_bar.sh &

#Compositor
picom -f &

#Wallpaper
nitrogen --restore &

# unclutter to make the mouse dissapear when not using it
unclutter &

# insync start
insync start

# change esc with caps lock
setxkbmap -option caps:escape

# Loop
while true; do
	dwm > /dev/null 2>&1
done

#Execute DWM
exec dwm
