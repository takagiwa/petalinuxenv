# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.define "vagrant-ubuntu18044"
    config.vm.box = "bionic64"
    config.ssh.username = "vagrant"
    config.ssh.password = "vagrant
end
