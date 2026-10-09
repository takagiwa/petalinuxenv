#
# Vagrant file
# https://github.com/takagiwa/petalinuxenv
#
Vagrant.configure("2") do |config|

  config.vm.boot_timeout = 6000
  config.vm.provision "file", source: "peta_expect_3.exp", destination: "/home/vagrant/peta_expect_3.exp"

  # edit below

  # box name
  config.vm.box = "jammy3"
  # hostname
  config.vm.hostname = "xilinx2025-2"

  config.vm.provider "virtualbox" do |v|
    # virtual machine name
    v.name = "xilinx2025.2"
    # number of CPU cores
    v.cpus = 4
    # memory size
    v.memory = 8192
  end

  # enable this line if you want to add bridged network
  #config.vm.network "public_network", bridge: "Realtek Gaming 2.5GbE Family Controller #2"

  # https://pcvogel.sarakura.net/2023/02/23/38020
  # $ sudo XAUTHORITY=${HOME}/.Xauthority su
  config.ssh.forward_x11 = true

  config.vm.provision "shell",
    env: {
      # ISO image file name
      "ISO_FILENAME" => "ubuntu-22.04.3-live-server-amd64.iso",
      # Vitis/Vivado installer filename (basename = except extention)
      "VIVADO_FILENAME" => "FPGAs_AdaptiveSoCs_Unified_SDI_2025.2_1114_2157",
      # Vitis/Vivado batch install configuration file name
      "CONFIG_FILENAME" => "batch_config/xilinxconfig_2025.2_vitis.txt",
      # Vitis/Vivado/Petalinux version name
      "VERSION_STR" => "2025.2",
      # Petalinux installer filename
      "PETALINUX_FILENAME" => "petalinux-v2025.2-11160223-installer.run"
   }, path: "peta_install_4.sh"

  config.vm.synced_folder ".\\work", "/home/vagrant/work", create: true, mount_options: ["dmode=755", "fmode=644"]
  # Directory/Folder name of Vitis/Vivado/Petalinux installer and configuration file
  config.vm.synced_folder "W:\\XilinxInstaller", "/mnt/xilinxinstaller", create: true, mount_options: ["dmode=755", "fmode=755"]
  # Directory/Folder name of ISO image files
  config.vm.synced_folder "W:\\iso", "/mnt/iso", create: true, mount_options: ["dmode=755", "fmode=755"]
end
