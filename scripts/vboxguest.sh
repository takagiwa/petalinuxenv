#!/bin/bash
sudo mount -o loop /home/$1/VBoxGuestAdditions.iso /media/cdrom
sudo sh /media/cdrom/VBoxLinuxAdditions.run
sudo umount /media/cdrom
