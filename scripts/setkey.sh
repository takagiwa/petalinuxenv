#!/bin/sh
/bin/mkdir /home/$1/.ssh
/bin/chmod 700 /home/$1/.ssh
/usr/bin/curl -L -o /home/$1/.ssh/id_rsa https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant
/usr/bin/curl -L -o /home/$1/.ssh/authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
/bin/chown -R $1:$1 /home/$1/.ssh
/bin/chmod 0600 /home/$1/.ssh/*
