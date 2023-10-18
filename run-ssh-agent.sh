#!/usr/bin/fish
eval (ssh-agent -t 10m -c); and ssh-add ~/.ssh/personal_id_ed25519_2023-05

