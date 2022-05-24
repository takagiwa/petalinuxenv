#!/bin/bash

#
# need to be modified for variable user name
#
echo "vagrant ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 440 /etc/sudoers.d/vagrant
