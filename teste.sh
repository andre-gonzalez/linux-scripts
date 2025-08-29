#!/bin/bash

# Unlock the vault (you'll be prompted for your master password once)
bw unlock --raw > ~/.bw_session

export BW_SESSION=$(cat ~/.bw_session)

# Fetch all item names
items=$(bw list items --session $BW_SESSION | jq -r '.[].name')

# Select the desired item with dmenu
selected=$(echo "$items" | dmenu -p "Bitwarden item:")

if [ -n "$selected" ]; then
    # Get the ID of the selected item
    id=$(bw list items --session $BW_SESSION | jq -r ".[] | select(.name==\"$selected\") | .id")

    # Get the password for the selected item
    password=$(bw get password $id --session $BW_SESSION)

    # Copy password to X11 clipboard
    echo -n "$password" | xclip -selection clipboard

    # Notify the user
    notify-send "Bitwarden" "Password for '$selected' copied to clipboard"
fi
