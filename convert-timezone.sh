#!/bin/sh

# 2025-06-12 Thu 07:30 PM
# This script receive a hour and a timezone as input and outputs the hour
# in your computer timezone
# It can read the hour and timezone from stdinput, from dmenu
# or directly from the terminal

if [ $# -eq 2 ]; then
	HOUR=$1
	TIMEZONE=$2
else
	HOUR="$(echo "9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20\n21\n22\n23\n24\n1\n2\n3\n4\n5\n6\n7\n8" | dmenu -p "Hour:")"
	TIMEZONE="$(echo "PST\nEST\nGMT+1\nGMT+2\nUTC\nCST\nGMT-4\nGMT-6\nGMT-3\nCET" | dmenu -p "Timezone:")"
# Adicionar lógica fallback aqui que se as variaveis ainda estiverem vazias de ler com read
# elif
# read -r -p 'Hours: ' HOUR
# read -r -p 'Timezone: ' TIMEZONE
fi

notify-send "In your timezone" "$(date "+%H %p %Z"  -d "$HOUR $TIMEZONE")"
echo "In your timezone:\n" "$(date "+%H %p %Z"  -d "$HOUR $TIMEZONE")"
