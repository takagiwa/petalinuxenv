#
# Vagrant file
# https://github.com/takagiwa/petalinuxenv
#
Vagrant.configure("2") do |config|

  config.vm.boot_timeout = 6000
  config.vm.provision "file", source: "peta_expect_2.exp", destination: "/home/vagrant/peta_expect_2.exp"

  # edit below

  # box name
  config.vm.box = "bionic4"
  # hostname
  config.vm.hostname = "xilinx2022-1"

  config.vm.provider "virtualbox" do |v|
    # virtual machine name
    v.name = "xilinx2022.1"
    # number of CPU cores
    v.cpus = 4
    # memory size
    v.memory = 8192
  end

  # enable this line if you want to add bridged network
  #config.vm.network "public_network", bridge: "Realtek Gaming 2.5GbE Family Controller #2"

  config.vm.provision "shell",
    env: {
      # ISO image file name
      "ISO_FILENAME" => "ubuntu-18.04.4-server-amd64.iso",
      # Vitis/Vivado installer filename (basename = except extention)
      "VIVADO_FILENAME" => "Xilinx_Unified_2022.1_0420_0327",
      # Vitis/Vivado batch install configuration file name
      "CONFIG_FILENAME" => "batch_config/xilinxconfig_2022.1_vitis.txt",
      # Vitis/Vivado/Petalinux version name
      "VERSION_STR" => "2022.1",
      # Petalinux installer filename
      "PETALINUX_FILENAME" => "petalinux-v2022.1-04191534-installer.run"
   }, path: "peta_install_2.sh"

  config.vm.synced_folder ".\\work", "/home/vagrant/work", create: true, mount_options: ["dmode=755", "fmode=644"]
  # Directory/Folder name of Vitis/Vivado/Petalinux installer and configuration file
  config.vm.synced_folder "W:\\XilinxInstaller", "/mnt/xilinxinstaller", create: true, mount_options: ["dmode=755", "fmode=755"]
  # Directory/Folder name of ISO image files
  config.vm.synced_folder "W:\\iso", "/mnt/iso", create: true, mount_options: ["dmode=755", "fmode=755"]
end
