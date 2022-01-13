#!/bin/sh

answer="$( echo "work\npessoal\noutro" | dmenu -i -p "O que você deseja fazer" )"

case $answer in
		"work")
				/usr/bin/dash /usr/local/bin/work
		;;
		"pessoal")
				/usr/bin/dash /usr/local/bin/pessoal
		;;
esac
