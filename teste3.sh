#!/bin/bash

SESSION_FILE="$HOME/.cache/bw_session"

# Load session from file if it exists
if [[ -f "$SESSION_FILE" ]]; then
    BW_SESSION=$(<"$SESSION_FILE")

    # Check if session is still valid
    if ! bw sync --session "$BW_SESSION" &>/dev/null; then
        unset BW_SESSION
    fi
fi

# If session is not valid, prompt for unlock
if [[ -z "$BW_SESSION" ]]; then
    master_password=$(echo "" | dmenu -p "Bitwarden Master Password:")
    if [[ -z "$master_password" ]]; then
        notify-send "Bitwarden" "Vault unlock cancelled."
        exit 1
    fi

    BW_SESSION=$(echo "$master_password" | bw unlock --raw 2>/dev/null)
    if [[ -z "$BW_SESSION" ]]; then
        notify-send "Bitwarden" "Failed to unlock vault."
        exit 1
    fi

    echo "$BW_SESSION" > "$SESSION_FILE"
fi

export BW_SESSION

# Fetch item names
items=$(bw list items --session "$BW_SESSION" | jq -r '.[].name' | sort)

if [[ -z "$items" ]]; then
    notify-send "Bitwarden" "No items found in vault."
    exit 1
fi

# Select item with dmenu
selected=$(echo "$items" | dmenu -p "Select Bitwarden item:")

if [[ -z "$selected" ]]; then
    notify-send "Bitwarden" "No item selected."
    exit 1
fi

# Get item ID
id=$(bw list items --session "$BW_SESSION" | jq -r ".[] | select(.name==\"$selected\") | .id")

if [[ -z "$id" ]]; then
    notify-send "Bitwarden" "Failed to find item ID."
    exit 1
fi

# Get password and copy to clipboard
password=$(bw get password "$id" --session "$BW_SESSION")

if [[ -z "$password" ]]; then
    notify-send "Bitwarden" "Password not found for '$selected'."
    exit 1
fi

echo -n "$password" | xclip -selection clipboard
notify-send "Bitwarden" "Password for '$selected' copied to clipboard."
