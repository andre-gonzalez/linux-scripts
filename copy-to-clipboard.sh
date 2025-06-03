#!/bin/sh

# This script pipes a file into dmenu and put the text in the clipboard based
# on the selection madeLIST="$HOME/projects/notas/pessoal/copy_to_clipboard.md"

LIST="$HOME/projects/notas/pessoal/copy_to_clipboard.md"

SELECTION=$(dmenu -p "Copy:" -l 50 <"$LIST")

TEXT=$(echo "$SELECTION" | sed 's/^[^|]*|//; s/^[ \t]*//; s/[ \t]*$//')

# Replace || with newlines, trim leading spaces on each line, and replace <<TAB>> with actual tab characters
PROCESSED=$(echo "$TEXT" | sed 's/||/\
/g' | sed 's/^[ \t]*//' | sed 's/<<TAB>>/\t/g')

echo "$PROCESSED" | xclip -r -selection clipboard
