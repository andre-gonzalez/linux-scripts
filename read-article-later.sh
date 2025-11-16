#!/bin/sh

# config / env
WALLABAG_URL="http://servarr.ewe-musical.ts.net:7780"
CLIENT_ID=$(grep -Po '(?<=wallabag_client_id=).*' "$HOME/.scripts/.env/wallabag")
CLIENT_SECRET=$(grep -Po '(?<=wallabag_client_secret=).*' "$HOME/.scripts/.env/wallabag")
USERNAME=$(grep -Po '(?<=wallabag_user=).*' "$HOME/.scripts/.env/wallabag")
PASSWORD=$(grep -Po '(?<=wallabag_password=).*' "$HOME/.scripts/.env/wallabag")

# get URL and title
url=$(xclip -o -sel clip)
title=$(curl -sL "$url" | grep -Po '(?<=<title>).*(?=</title>)' | sed 's/"/\"/g')

# get OAuth token (bearer)
token_response=$(curl -s --request POST \
  --url "$WALLABAG_URL/oauth/v2/token" \
  --header 'Content-Type: application/x-www-form-urlencoded' \
  --data "grant_type=password&client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&username=$USERNAME&password=$PASSWORD")
access_token=$(echo "$token_response" | grep -Po '"access_token"\s*:\s*"\K[^"]+')

# check token
if [ -z "$access_token" ]; then
  notify-send "wallabag" "Error: could not get access token"
  exit 1
fi

# send article
add_response=$(curl -s --request POST \
  --url "$WALLABAG_URL/api/entries.json" \
  --header "Authorization: Bearer $access_token" \
  --header 'Content-Type: application/json' \
  --data "{\"url\":\"$url\",\"title\":\"$title\"}")

# optionally inspect for success
if echo "$add_response" | grep -q '"id":'; then
  notify-send "wallabag" "Sent: $title"
else
  notify-send "wallabag" "Failed to send: $title"
  echo "$add_response" >&2
fi
