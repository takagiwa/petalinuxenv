# variables
# xilinxconfigfile (xilinxconfig_2017.3_webpack.txt|xilinxconfig_2017.3_design.txt|xilinxconfig_2017.3_system.txt)
# desktop environment (none|ubuntu-desktop|xubuntu-desktop)
# v.cpus
# v.memory
# config.vm.synced_folder "F:\\XilinxInstaller"
# config.vm.synced_folder "F:\\iso"

$install_script = <<-'SCRIPT'
# TODO: error check

# TODO: all synced_folder exist check

# TODO: check iso file exist
sudo mkdir /mnt/dvdiso
echo '/mnt/iso/ubuntu-16.04.1-server-amd64.iso /mnt/dvdiso iso9660 loop,ro,auto,nofail 0 0' >> /etc/fstab
sudo mount /mnt/dvdiso
sudo sed -i -e 's/\/media\/cdrom/\/mnt\/dvdiso/g' /etc/apt/apt.conf.d/00CDMountPoint
sudo apt-cdrom -m -d /mnt/dvdiso add

echo 'waiting for apt.systemd.daily'
#wait `pgrep apt.systemd.dai`
PID=`pgrep apt.systemd.dai`
if [ -n "$PID" ]; then
  while [ -e /proc/$PID ]
  do
    sleep 1
  done
fi
echo 'install required packages'
sudo apt install -y python3 tofrodos iproute2 gawk xvfb gcc-4.8 git make net-tools libncurses5-dev tftpd zlib1g-dev:i386 libssl-dev flex bison libselinux1 gnupg wget diffstat chrpath socat xterm autoconf libtool tar unzip texinfo zlib1g-dev gcc-multilib build-essential  libsdl1.2-dev libglib2.0-dev screen pax gzip libgtk2.0-0

# change shell from dash to bash
# https://www.nemotos.net/?p=3419
echo "dash dash/sh boolean false" | sudo debconf-set-selections
sudo dpkg-reconfigure --frontend=noninteractive dash

# choose one of the desktop environment if needed
#sudo apt install -y ubuntu-desktop
#sudo apt install -y xubuntu-desktop

echo 'install Vivado'
cd /home/vagrant
tar zvxf /mnt/xilinxinstaller/Xilinx_Vivado_SDK_2017.3_1005_1.tar.gz
chown -R vagrant:vagrant ./Xilinx_Vivado_SDK_2017.3_1005_1
cd Xilinx_Vivado_SDK_2017.3_1005_1
# choose configuration file
sudo ./xsetup --agree XilinxEULA,3rdPartyEULA,WebTalkTerms --batch Install --config /mnt/xilinxinstaller/xilinxconfig_2017.3_webpack.txt
cd ..
rm -rf ./Xilinx_Vivado_SDK_2017.3_1005_1

echo 'install Petalinux'
mkdir -p /home/vagrant/petalinux/2017.3
sudo chown -R vagrant:vagrant /home/vagrant/petalinux
sudo chmod +x /mnt/xilinxinstaller/petalinux-v2017.3-final-installer.run
# license agreement required
# Failed to install automatically. Need to install manually.
yes | sudo -u vagrant /mnt/xilinxinstaller/petalinux-v2017.3-final-installer.run /home/vagrant/petalinux/2017.3 > /dev/null 2>&1
source /home/vagrant/petalinux/2017.3/settings.sh
petalinux-util --webtalk off

echo 'source /opt/Xilinx/Vivado/2017.3/settings64.sh' >> /home/vagrant/.bash_profile
echo 'source /home/vagrant/petalinux/2017.3/settings.sh' >> /home/vagrant/.bash_profile
chown vagrant:vagrant /home/vagrant/.bash_profile
chmod 644 /home/vagrant/.bash_profile

sudo chown -R vagrant:vagrant /home/vagrant/petalinux

SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "xenial1"
  config.vm.hostname = "xilinx2017.3"
  config.vm.boot_timeout = 6000

  config.vm.provider "virtualbox" do |v|
    v.name = "xilinx2017.3"
    v.cpus = 4
    # Memory in MB
    v.memory = 8192
  end

  config.vm.provision "shell", inline: $install_script

  config.vm.synced_folder ".\\work", "/home/vagrant/work", create: true, mount_options: ["dmode=755", "fmode=644"]
  config.vm.synced_folder "G:\\XilinxInstaller", "/mnt/xilinxinstaller", create: true, mount_options: ["dmode=755", "fmode=755"]
  config.vm.synced_folder "G:\\iso", "/mnt/iso", create: true, mount_options: ["dmode=755", "fmode=755"]
end

# https://www.xilinx.com/content/dam/xilinx/support/documents/sw_manuals/xilinx2017_3/ug973-vivado-release-notes-install-license.pdf
# p31 Batch Mode Installation Flow

# TODO: install desktop environment
# TODO: add synced_folder for home directory
