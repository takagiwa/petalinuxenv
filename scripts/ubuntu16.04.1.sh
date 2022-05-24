#!/bin/sh

#
# Add key
#
/bin/mkdir /home/vagrant/.ssh
/bin/chmod 700 /home/vagrant/.ssh
/usr/bin/curl -L -o /home/vagrant/.ssh/id_rsa https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant
/usr/bin/curl -L -o /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
/bin/chown -R vagrant:vagrant /home/vagrant/.ssh
/bin/chmod 0600 /home/vagrant/.ssh/*
