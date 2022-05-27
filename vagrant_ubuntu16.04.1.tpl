# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.define "vagrant-ubuntu16041"
    config.vm.box = "xenial64"
    config.ssh.username = "vagrant"
    config.ssh.password = "vagrant
end
