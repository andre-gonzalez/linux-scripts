#!bin/sh
[ $(echo -e "No\nYes" | dmenu -i -p "Starting working now?") \ == "Yes" ] &&


while true
do
  # (1) prompt user, and read command line argument
  read -p "Run the cron script now? " answer

  # (2) handle the input we were given
  case $answer in
  [yY]* ) echo "você apertou sim"
	break;;
  [nN]* ) exit;;
  esac
done
