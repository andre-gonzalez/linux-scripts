#!/bin/sh

# This script pipes a file into dmenu and put the text in the clipboard based
# on the selection madeLIST="$HOME/projects/notas/pessoal/copy_to_clipboard.md"

LIST="$HOME/projects/notas/pessoal/copy_to_clipboard.md"

SELECTION=$(dmenu -p "Copy:" -l 50 <"$LIST")

TEXT=$(echo "$SELECTION" | sed 's/^[^|]*|//; s/^[ \t]*//; s/[ \t]*$//')

PROCESSED=$(echo "$TEXT" | sed 's/||/\
/g' | sed 's/^[ \t]*//')

echo "$PROCESSED" | xclip -r -selection clipboard
