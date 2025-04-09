#
# Vagrant file
# https://github.com/takagiwa/petalinuxenv
#
Vagrant.configure("2") do |config|

  config.vm.boot_timeout = 6000
  config.vm.provision "file", source: "peta_expect_3.exp", destination: "/home/vagrant/peta_expect_3.exp"

  # edit below

  # box name
  config.vm.box = "focal4"
  # hostname
  config.vm.hostname = "xilinx2024-1"

  config.vm.provider "virtualbox" do |v|
    # virtual machine name
    v.name = "xilinx2024.1"
    # number of CPU cores
    v.cpus = 4
    # memory size
    v.memory = 8192
  end

  # https://pcvogel.sarakura.net/2023/02/23/38020
  # $ sudo XAUTHORITY=${HOME}/.Xauthority su
  config.ssh.forward_x11 = true

  config.vm.provision "shell",
    env: {
      # ISO image file name
      "ISO_FILENAME" => "ubuntu-20.04.4-live-server-amd64.iso",
      # Vitis/Vivado installer filename (basename = except extention)
      "VIVADO_FILENAME" => "FPGAs_AdaptiveSoCs_Unified_2024.1_0522_2023",
      # Vitis/Vivado batch install configuration file name
      "CONFIG_FILENAME" => "batch_config/xilinxconfig_2024.1_vitis.txt",
      # Vitis/Vivado/Petalinux version name
      "VERSION_STR" => "2024.1",
      # Petalinux installer filename
      "PETALINUX_FILENAME" => "petalinux-v2024.1-05202009-installer.run"
   }, path: "peta_install_3.sh"

  config.vm.synced_folder ".\\work", "/home/vagrant/work", create: true, mount_options: ["dmode=755", "fmode=644"]
  # Directory/Folder name of Vitis/Vivado/Petalinux installer and configuration file
  config.vm.synced_folder "W:\\XilinxInstaller", "/mnt/xilinxinstaller", create: true, mount_options: ["dmode=755", "fmode=755"]
  # Directory/Folder name of ISO image files
  config.vm.synced_folder "W:\\iso", "/mnt/iso", create: true, mount_options: ["dmode=755", "fmode=755"]
end
