# petalinuxenv

Packer scripts and Vagrant files to make Xilinx Vivado and Petalinux enviroment.

[VirtualBox plugin](https://developer.hashicorp.com/packer/integrations/hashicorp/virtualbox) and [Vagrant plugin](https://developer.hashicorp.com/packer/integrations/hashicorp/vagrant) are needed.

You need
* HashiCorp Packer
* HashiCorp Vagrant
* Ubuntu ISO files
* Vivado or Vitis full install images
* Petalinux install files
* Vivado or Vitis install configuration files
* SSH terminal software (e.g. TeraTerm)
* X server (e.g. Xming, MobaXterm, VcXsrv)

You can make install configuration file

```
xsetup -b ConfigGen
```

Create Vagrant boxes as below.

```
packer build --force -var-file=<Variables file> <Packer script>
vagrant box add --force <Box name> packer_ubuntu_virtualbox.box
```

Vriables file, Packer script, Box name are below.

| Ubuntu | Box name | Packer script | Variables file |
| ------ | -------- | ------------- | -------------- |
| 16.04.1 | xenial1 | ubuntu16.04.pkr.hcl | ubuntu16.04.1.pkrvars.hcl |
| 16.04.3 | xenial3 | ubuntu16.04.pkr.hcl | ubuntu16.04.3.pkrvars.hcl |
| 18.04.1 | bionic1 | ubuntu18.04.pkr.hcl | ubuntu18.04.1.pkrvars.hcl |
| 18.04.4 | bionic4 | ubuntu18.04.pkr.hcl | ubuntu18.04.4.pkrvars.hcl |
| 20.04.3 | focal3  | ubuntu20.04.pkr.hcl | ubuntu20.04.3.pkrvars.hcl |
| 20.04.4 | focal4  | ubuntu20.04.pkr.hcl | ubuntu20.04.4.pkrvars.hcl |

Next, copy the script for the Petalinux version you want to run into a working directory of your choice.

| Petelinux version | Ubuntu | Box name | Scripts |
| ----------------- | ------ | -------- | ------- |
| 2014.4            | - | - | - |
| 2015.2.1          | - | - | - |
| 2015.4            | - | - | - |
| 2016.1            | - | - | - |
| 2016.2            | - | - | - |
| 2016.3            | - | - | - |
| 2016.4            | - | - | - |
| 2017.1            | 16.04.1 | xenial1 | vagrantfile_xilinx2017.1.tpl, peta_install_1.sh |
| 2017.2            | 16.04.1 | xenial1 | vagrantfile_xilinx2017.2.tpl, peta_install_1.sh |
| 2017.3            | 16.04.1 | xenial1 | vagrantfile_xilinx2017.3.tpl, peta_install_1.sh |
| 2017.4            | 16.04.1 | xenial1 | vagrantfile_xilinx2017.4.tpl, peta_install_1.sh |
| 2018.1            | 16.04.3 | xenial3 | vagrantfile_xilinx2018.1.tpl, peta_install_1.sh |
| 2018.2            | 16.04.3 | xenial3 | vagrantfile_xilinx2018.2.tpl, peta_install_1.sh |
| 2018.3            | 16.04.3 | xenial3 | vagrantfile_xilinx2018.3.tpl, peta_install_1.sh |
| 2019.1            | - | - | - |
| 2019.2            | - | - | - |
| 2020.1            | - | - | - |
| 2020.2            | - | - | - |
| 2021.1            | 18.04.4 | bionic4 | vagrantfile_xilinx2021.1.tpl, peta_install_2.sh, peta_expect_2.exp |
| 2021.2            | 18.04.4 | bionic4 | vagrantfile_xilinx2021.2.tpl, peta_install_2.sh, peta_expect_2.exp |
| 2022.1            | 18.04.4 | bionic4 | vagrantfile_xilinx2022.1.tpl, peta_install_2.sh, peta_expect_2.exp |
| 2022.2            | 18.04.4 | bionic4 | vagrantfile_xilinx2022.2.tpl, peta_install_2.sh, peta_expect_2.exp |
| 2023.1            | - | - | - |
| 2023.2            | - | - | - |
| 2024.1            | 20.04.4 | focal4 | vagrantfile_xilinx2024.1.tpl, peta_install_3.sh, peta_expect_3.exp |
| 2024.2            | - | - | - |
| 2025.1            | - | - | - |
| 2025.2            | - | - | - |

Edit *.tpl file and rename *.tpl file to "Vagrantfile". Also edit Vivado or Vitis install configuration file. Then run

* config.vm.hostname : VM hostname
* v.name : VirtualBox VM name
* v.cpus : number of CPUs
* v.memory : Assign memory
* config.vm.synced_folder ".\\work" : shared directory
* config.vm.synced_folder "W:\\XilinxInstaller" : where Xilinx file installed in host
* config.vm.synced_folder "W:\\iso" : where Ubuntu ISO placed
* "CONFIG_FILENAME" : Vivado or Vitis install configuration file path


```
vagrant up
```

