#
# Vagrant file
# https://github.com/takagiwa/petalinuxenv
#
Vagrant.configure("2") do |config|

  config.vm.boot_timeout = 6000

  # edit below

  # box name
  config.vm.box = "xenial3"
  # hostname
  config.vm.hostname = "xilinx2018-3"

  config.vm.provider "virtualbox" do |v|
    # virtual machine name
    v.name = "xilinx2018.3"
    # number of CPU cores
    v.cpus = 4
    # memory size
    v.memory = 8192
  end

  config.vm.provision "shell",
    env: {
      # ISO image file name
      "ISO_FILENAME" => "ubuntu-16.04.3-server-amd64.iso",
      # Vitis/Vivado installer filename (basename = except extention)
      "VIVADO_FILENAME" => "Xilinx_Vivado_SDK_2018.3_1207_2324",
      # Vitis/Vivado batch install configuration file name
      "CONFIG_FILENAME" => "batch_config/xilinxconfig_2018.3_webpack.txt",
      # Vitis/Vivado/Petalinux version name
      "VERSION_STR" => "2018.3",
      # Petalinux installer filename
      "PETALINUX_FILENAME" => "petalinux-v2018.3-final-installer.run"
   }, path: "peta_install_1.sh"

  config.vm.synced_folder ".\\work", "/home/vagrant/work", create: true, mount_options: ["dmode=755", "fmode=644"]
  # Directory/Folder name of Vitis/Vivado/Petalinux installer and configuration file
  config.vm.synced_folder "W:\\XilinxInstaller", "/mnt/xilinxinstaller", create: true, mount_options: ["dmode=755", "fmode=755"]
  # Directory/Folder name of ISO image files
  config.vm.synced_folder "W:\\iso", "/mnt/iso", create: true, mount_options: ["dmode=755", "fmode=755"]
end
