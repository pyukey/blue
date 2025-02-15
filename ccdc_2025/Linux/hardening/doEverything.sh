#!/bin/sh
if [ "$(id -u)" -ne 0 ]; then
  echo "You must run this script as root!"
  exit
fi

printf "/033[01mBegin Blackout/033[00m\n"
./blackout.sh
printf "/033[01mChanging passwords/033[00m\n"
./pass.sh
printf "You should /033[01msave these passwords/033[00m and update the score checker! Say something when you are ready to continue: "
read ans
printf "/033[01mBegin hardening/033[00m of users\n"
./fixUsers.sh
printf "Here are your final configurations. Good luck hardening!\n"
