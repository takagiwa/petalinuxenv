#!/bin/bash

# https://www.gun.io/blog/building-vagrant-machines-with-packer
# set -e

# apt update -y -qq > /dev/null
# apt install -y linux-headers-$(uname -r) build-essential dkms nfs-common
# apt install -y curl git

# https://www.covermymeds.com/main/insights/articles/repeatable-vagrant-builds-with-packer/
# setup insecure vagrant user ssh key
/bin/mkdir /home/vagrant/.ssh
/bin/chmod 700 /home/vagrant/.ssh
/usr/bin/curl -L -o /home/vagrant/.ssh/id_rsa https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant
/usr/bin/curl -L -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
/bin/chown -R vagrant:vagrant /home/vagrant/.ssh
/bin/chmod 0600 /home/vagrant/.ssh/*
