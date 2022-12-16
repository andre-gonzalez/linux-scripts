#!/bin/sh

cp -f "$HOME"/.local/share/fish/fish_history "$HOME"/gdrive-pessoal/pessoal/programação/ansible/main-ansible/files/
cd "$HOME"/gdrive-pessoal/pessoal/programação/ansible/main-ansible/ && ansible-vault encrypt ./files/fish_history
git add ./files/fish_history
git commit -m "update fish_history file $(date "+%Y-%m-%d-%R")"
git push -q -u origin main
