#!/bin/sh

# This script pipes a file into dmenu and put the text in the clipboard based
# on the selection made

LIST="$HOME/gdrive-pessoal/pessoal/obsidian/pessoal/copy_to_clipboard.md"

SELECTION=$(dmenu -p "Copy:" -l 50 < $LIST)

echo $SELECTION | awk -F '|' '{print $2}' | xargs | xclip -r
