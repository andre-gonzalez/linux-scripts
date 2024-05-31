#!/bin/sh

NOW=$(date +%Y-%m-%d_%T)
cd "$HOME"/projects/notas/ &&
	git pull &&
	git add -A &&
	git commit -am "$NOW" &&
	git push -q -u origin main

curl https://hc-ping.com/fde92570-863b-4c76-a1c1-567c6f321a00
