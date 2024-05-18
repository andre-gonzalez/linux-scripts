#!/bin/sh

# title=$(xprop | awk '/^WM_NAME/{sub(/.* =/, "title:"); print}' | sed 's/^[^"]*"\([^"]*\)".*/\1/')
title=$(xprop -id "0x1a00025" | awk '/^WM_NAME/{print $3}' | sed 's/^[^"]*"\([^"]*\)".*/\1/')
echo "$title"

# case "$title" in
# 	"eureciclo") qutebrowser --basedir ~/eureciclo/qutebrowser/ $1 --target tab;;
# esac

