#!/bin/sh
# This is script is intended to start redshift program using your ip geolocation
# To use it is necessary to have a free account on https://ipinfo.io/
# Save you ipinfo.io token as a shell variable on the following path ./env/ipnfo

export $(grep -v '^#' .env/ipinfo | xargs)

tmpfile=$(mktemp /tmp/geo_location.XXXXXX)

curl -s "ipinfo.io/$(curl -s https://ipinfo.io/ip)?token=$token" | grep loc | grep -oE '\-?[0-9]{2}\.[0-9]{4}' > "$tmpfile"

echo "Starting redshift on $(head -n 1 $tmpfile):$(tail -n 1 $tmpfile) location"
notify-send "Redshift"  "Starting redshift on $(head -n 1 $tmpfile):$(tail -n 1 $tmpfile) location"

redshift -l $(head -n 1 $tmpfile):$(tail -n 1 $tmpfile) -t 6500:3000 -b 1:0.4
