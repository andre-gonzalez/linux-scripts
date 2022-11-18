#/bin/sh

NOW=$(date +%Y-%m-%d_%T)
cd "$HOME"/gdrive-pessoal/pessoal/obsidian && git add -A && git commit -am "$NOW" && git push -u origin main
