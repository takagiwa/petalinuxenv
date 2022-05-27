# petalinuxenv

Packer scripts and Vagrant files to make Xilinx Vivado and Petalinux enviroment.

2022 May 27

Tested with Windows 10 Pro 64bit 21H2 19044.1706, VirtualBox 6.1.34 r150636, Packer 1.7.10 and Vagrant 2.2.19. Not tested on Windows 11 and Linux.

Currently supports Vivado and Petalinux 2017.3 on Ubuntu server 16.04.1 .

***There are so many magic numbers and words on the scripts.***

Install Hashicorp Packer and Vagrant.

Also install SSH terminal (for example: TeraTerm SSH) and X server (for example: Xming, MobaXterm)

Download full installer from Xilinx into local directory.

- Xilinx_Vivado_SDK_2017.3_1005_1.tar.gz
- petalinux-v2017.3-final-installer.run

Also download Ubuntu server 16.04.1 from Ubuntu.

- ubuntu-16.04.1-server-amd64.iso

Edit files depends on your environment.

ubuntu16.04.1.pkrvars.hcl

Edit file path of **iso_url**.

scripts/add2sudoer.sh and scripts/setkey.sh

Replace **"vagrant"** if you want to change user name.

scripts/vboxguest.sh

Replace **"vagrant"** if you want to change user name.

File name of VirtualBox Guest Addions need to be modifled like **"VBoxGuestAdditions_6.1.34.iso"** (verion number depends on your version).

run Paker and make box file

```
packer build --force -var-file=ubuntu16.04.1.pkrvars.hcl ubuntu16.04.1.pkr.hcl
```

Register box file to Vagrant

```
vagrant box add --force xenial1-test packer_ubuntu_virtualbox.box
```

This box file also maybe used for Xilinx tools 2017.1, 2017.2 and 2017.4.

Copy **xilinxconfig_2017.3_*.txt** into a directory where you place Xilinx installer.
Modify one of the **xilinxconfig_2017.3_*.txt** file that you want to install (webpack, design edition, system edition).

Edit vagrant file vagrantfile_xilinx2017.3.tpl

Activeate ubuntu-desktop or xubuntu-desktop if you want to setup desktop environment.

On a line of **"xsetup"** Modify filename of **"xilinxconfig_2017.3_webpack.txt"** to that you want to setup 

on a line of **"v.cpus"** modify number of logical processor.

on a line of **"v.memory"** modify main memory size in MB.

Modify **"F:\\XilinxInstaller"** to your directory name that you Xilinx installer placed.

Modify **"F:\\iso"** to your directory name that you Ubuntu ISO image placed.

run X server in advance.

run vagrant

```
mkdir xenial1
cd xenial1
mkdir home
copy ..\vagrantfile_xilinx2017.3.tpl .\Vagrantfile
vagrant up
```

you can log in to the virtual machine **"localhost:2222"** user name "vagrant" and password "vagrant".

you can shutdown the virtual machine by

```
vagrant halt
```

you can delete the virtual machine by

```
vagrant destroy
```

you can remove box file by

```
vagrant box remove xenial1-test
```
