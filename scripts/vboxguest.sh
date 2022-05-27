#!/bin/bash

#
# FIXME: username and version of Guest Additions.
#
sudo mount -o loop /home/vagrant/VBoxGuestAdditions_6.1.34.iso /media/cdrom
sudo sh /media/cdrom/VBoxLinuxAdditions.run
sudo umount /media/cdrom
