#!/bin/sh

/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME add $HOME/.local/share/fish/fish_history
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME commit -m "$(date "+%Y-%m-%d %R") updated fish_history"
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME push -u origin main
