# petalinuxenv

Packer scripts and Vagrant files to make Xilinx Vivado and Petalinux enviroment.

[VirtualBox plugin](https://developer.hashicorp.com/packer/integrations/hashicorp/virtualbox) and [Vagrant plugin](https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant) are needed.

## 2025 Apr

Add Vivado and Petalinux 2021.1, 2022.2 and 2024.1 support.

Also Ubuntu server 20.04 support.

To run 2024.1, you need to copy "vagrantfile_xilinx2024.1.tpl" (as Vagrantfile. also need to be edited for your environment), "peta_install_3.sh" and "peta_expect_3.exp" and run "vagrant up".


## 2024 Dec 5

Add Vivado and Petalinux 2021.2 on Ubuntu server 18.04.4

You need to copy "vagrantfile_xilinx2021.2.tpl" (as Vagrantfile. also need to be edited for your environment), "peta_install_2.sh" and "peta_expect_2.exp" and run "vagrant up".

2020.1 ~ 2023.2 maybe work but not tested.


## 2024 Sep 12

Tested with Windows 11 Pro 23H2 22631.4169, VirtualBox 7.0.18 r162988, Packer 1.11.2 and Vagrant 2.4.1.

Currently supports

- Vivado and Petalinux 2017.1~4 on Ubuntu server 16.04.1
- Vivado and Petalinux 2018.1~3 on Ubuntu server 16.04.3

You need to download Vivado and Petalinux full installer first.

Edit ubuntu16.04.1.pkrvars.hcl and/or ubuntu16.04.3.pkrvars.hcl for your environment. Mainly "iso_url" path.

run Packer and make box file

```
packer build --force -var-file=ubuntu16.04.1.pkrvars.hcl ubuntu16.04.pkr.hcl
```

Register box file to Vagrant

```
vagrant box add --force xenial1 packer_ubuntu_virtualbox.box
```

also

```
packer build --force -var-file=ubuntu16.04.3.pkrvars.hcl ubuntu16.04.pkr.hcl
vagrant box add --force xenial3 packer_ubuntu_virtualbox.box
```

copy "peta_install_1.sh" to your work directory.
Also copy one of the vagrant files (vagrantfile_xilinx201x.y.tpl) as "Vagrantfile".

Edit variables on the Vagrantfile for your environment. Mainly Directory/Folder names and CONFIG_FILENAME.

then run on the work directory.

```
Vagrant up
```

---

## 2022 May 27

Tested with Windows 10 Pro 64bit 21H2 19044.1706, VirtualBox 6.1.34 r150636, Packer 1.7.10 and Vagrant 2.2.19. Not tested on Windows 11 and Linux.

Currently supports

- Vivado and Petalinux 2017.3 on Ubuntu server 16.04.1
- Vivado and Petalinux 2017.4 on Ubuntu server 16.04.1
- Vivado and Petalinux 2019.2 on Ubuntu server 18.04.1
- Vitis, Vivado and Petalinux 2020.2 on Ubuntu server 2020.2

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

run Paker and make box file

```
packer build --force -var-file=ubuntu16.04.1.pkrvars.hcl ubuntu16.04.1.pkr.hcl
```

Register box file to Vagrant

```
vagrant box add --force xenial1 packer_ubuntu_virtualbox.box
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
vagrant box remove xenial1
```
