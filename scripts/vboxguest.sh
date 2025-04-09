#!/bin/bash
#ls -alF /home/$1
sudo apt update
sudo apt install -y gcc make perl build-essential
sudo mkdir -p /media/cdrom
if [ -e /home/$1/VBoxGuestAdditions.iso ]; then
  sudo mount -o loop /home/$1/VBoxGuestAdditions.iso /media/cdrom
elif [ -e /dev/cdrom ]; then
  sudo mount /dev/cdrom /media/cdrom
else
  # not found
  exit 1
fi
sudo sh /media/cdrom/VBoxLinuxAdditions.run
sudo umount /media/cdrom
