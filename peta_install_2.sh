#
# Install Vivado and Petalinux
# https://github.com/takagiwa/petalinuxenv
#
#
#

#
# File and directory check
#
if [ ! -d "/mnt/xilinxinstaller" ];then
  echo "INSTALLER_DIR not exists."
  exit 1
fi
if [ ! -d "/mnt/iso" ];then
  echo "ISO_DIR not exists."
  exit 1
fi
if [ ! -e "/mnt/iso/$ISO_FILENAME" ];then
  echo "ISO_FILE not exists."
  exit 1
fi
if [ ! -e "/mnt/xilinxinstaller/$VIVADO_FILENAME.tar.gz" ];then
  echo "VIVADO_FILE not exists."
  exit 1
fi
if [ ! -e "/mnt/xilinxinstaller/$CONFIG_FILENAME" ];then
  echo "CONFIG_FILE not exists."
  exit 1
fi
if [ ! -e "/mnt/xilinxinstaller/$PETALINUX_FILENAME" ]; then
  echo "PETALINUX_FILE not exists."
  exit 1
fi
if [ ! -e "/home/vagrant/peta_expect_2.exp" ]; then
  echo "expect file not exists."
  exit 1
fi

#
# Install packages
#
sudo mkdir /mnt/dvdiso
echo "/mnt/iso/$ISO_FILENAME /mnt/dvdiso iso9660 loop,ro,auto,nofail 0 0" >> /etc/fstab
sudo mount /mnt/dvdiso
sudo sed -i -e 's/\/media\/cdrom/\/mnt\/dvdiso/g' /etc/apt/apt.conf.d/00CDMountPoint
sudo apt-cdrom -m -d /mnt/dvdiso add

# https://unix.stackexchange.com/questions/315502/how-to-disable-apt-daily-service-on-ubuntu-cloud-vm-image
echo 'stop apt.systemd.daily'
systemctl stop apt-daily.service
systemctl kill --kill-who=all apt-daily.service

# wait until `apt-get updated` has been killed
while ! (systemctl list-units --all apt-daily.service | egrep -q '(dead|failed)')
do
  sleep 1;
done

apt-get -o Acquire::http::AllowRedirect=false update

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
sudo /bin/sed -i 's/http:/https:/g' /etc/apt/sources.list
sudo apt update
sudo apt install -y python3 tofrodos iproute2 gawk xvfb gcc-4.8 git make net-tools libncurses5-dev tftpd zlib1g-dev:i386 libssl-dev flex bison libselinux1 gnupg wget diffstat chrpath socat xterm autoconf libtool tar unzip texinfo zlib1g-dev gcc-multilib build-essential  libsdl1.2-dev libglib2.0-dev screen pax gzip libgtk2.0-0

echo 'install expect'

for i in {1..3}
do
  if [ ! -e "/usr/bin/expect" ]; then
   sudo apt update
   sudo apt install -y expect
 fi
done

#
# change shell from dash to bash
# https://www.nemotos.net/?p=3419
#
echo "dash dash/sh boolean false" | sudo debconf-set-selections
sudo dpkg-reconfigure --frontend=noninteractive dash

#
# choose one of the desktop environment if needed
#sudo apt install -y ubuntu-desktop
#sudo apt install -y xubuntu-desktop
#


echo 'install Vivado'
cd /home/vagrant
tar zvxf /mnt/xilinxinstaller/$VIVADO_FILENAME.tar.gz
chown -R vagrant:vagrant ./$VIVADO_FILENAME
cd $VIVADO_FILENAME
# choose configuration file
# ",WebTalkTerms" removed
sudo ./xsetup --agree XilinxEULA,3rdPartyEULA --batch Install --config /mnt/xilinxinstaller/$CONFIG_FILENAME
cd ..
rm -rf ./$VIVADO_FILENAME

if [ -d "/opt/Xilinx" ];then
  echo "source /opt/Xilinx/Vivado/$VERSION_STR/settings64.sh" >> /home/vagrant/.bash_profile
elif [ -d "/tools/Xilinx" ];then
  echo "source /tools/Xilinx/Vivado/$VERSION_STR/settings64.sh" >> /home/vagrant/.bash_profile
fi

chown vagrant:vagrant /home/vagrant/.bash_profile
chmod 644 /home/vagrant/.bash_profile


echo 'install Petalinux'
if [ ! -e "/usr/bin/expect" ]; then
  echo "expect command not installed. you need to install petalinux manually."
  exit 1
fi
mkdir -p /home/vagrant/petalinux/$VERSION_STR
sudo chown -R vagrant:vagrant /home/vagrant/petalinux
sudo chmod +x /mnt/xilinxinstaller/$PETALINUX_FILENAME
# license agreement required
#sudo -u vagrant /mnt/xilinxinstaller/$PETALINUX_FILENAME --dir /home/vagrant/petalinux/$VERSION_STR > /dev/null 2>&1
sudo -u vagrant /usr/bin/expect -f /home/vagrant/peta_expect_2.exp /mnt/xilinxinstaller/$PETALINUX_FILENAME /home/vagrant/petalinux/$VERSION_STR
source /home/vagrant/petalinux/$VERSION_STR/settings.sh
#petalinux-util --webtalk off

echo "source /home/vagrant/petalinux/$VERSION_STR/settings.sh" >> /home/vagrant/.bash_profile

sudo chown -R vagrant:vagrant /home/vagrant/petalinux
