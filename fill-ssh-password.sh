#!/bin/sh

fill-password-in-script.sh $(cat "$HOME"/.scripts/.env/ssh | grep -Po '(?<=ssh-password=).*') "Enter passphrase for key '/home/frank/.ssh/personal_id_ed25519_2023-05'"
