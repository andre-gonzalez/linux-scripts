#!/bin/sh

TMPFILE_DIR=/tmp/neovim-anywhere
TMPFILE=$TMPFILE_DIR/doc-$(date +"%y%m%d%H%M%S")

mkdir -p $TMPFILE_DIR
touch $TMPFILE

# Make the file only readble by you
chmod o-r $TMPFILE
st -t neovim-anywhere -c neovim-anywhere -e nvim $TMPFILE
cat $TMPFILE | xclip -selection clipboard
