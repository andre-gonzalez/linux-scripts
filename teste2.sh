#!/bin/bash

# Check if BW_SESSION is already set and valid
if [ -z "$BW_SESSION" ]; then
    # Prompt for master password (masked input, requires patched dmenu)
    master_password=$(dmenu -p "Bitwarden Master Password:")

    if [ -z "$master_password" ]; then
        notify-send "Bitwarden" "Vault unlock cancelled."
        exit 1
    fi

    # Unlock vault, output raw session key or exit on failure
    BW_SESSION=$(echo "$master_password" | bw unlock --raw 2>/dev/null)
    if [ -z "$BW_SESSION" ]; then
        notify-send "Bitwarden" "Failed to unlock vault."
        exit 1
    fi

    export BW_SESSION
else
    # Optionally verify BW_SESSION is valid by calling bw status
    if ! bw status --session "$BW_SESSION" | grep -q "unlocked"; then
        notify-send "Bitwarden" "Existing BW_SESSION invalid or expired. Please re-run."
        unset BW_SESSION
        exit 1
    fi
fi

# Fetch all item names
items=$(bw list items --session "$BW_SESSION" | jq -r '.[].name' | sort)

# Select item with dmenu
selected=$(echo "$items" | dmenu -i -p "Select Bitwarden item:")

if [ -z "$selected" ]; then
    notify-send "Bitwarden" "No item selected."
    exit 1
fi

# Get the item's ID
id=$(bw list items --session "$BW_SESSION" | jq -r ".[] | select(.name==\"$selected\") | .id")

# Get the password for the selected item
password=$(bw get password "$id" --session "$BW_SESSION")

# Copy password to clipboard
echo -n "$password" | xclip -selection clipboard

notify-send "Bitwarden" "Password for '$selected' copied to clipboard"
