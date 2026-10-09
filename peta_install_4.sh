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
  echo "[ERROR] INSTALLER_DIR not exists."
  exit 1
fi

_VIVADO_FILENAME=$(find /mnt/xilinxinstaller -maxdepth 1 -type f -name "${VIVADO_FILENAME}.*" -print -quit)
if [ -n "$_VIVADO_FILENAME" ]; then
  :
else
  echo "[ERROR] VIVADO_FILE not exists."
  exit 1
fi

if [ ! -e "/mnt/xilinxinstaller/$CONFIG_FILENAME" ];then
  echo "[ERROR] CONFIG_FILE not exists."
  exit 1
fi
if [ ! -e "/mnt/xilinxinstaller/$PETALINUX_FILENAME" ]; then
  echo "[ERROR] PETALINUX_FILE not exists."
  exit 1
fi
if [ ! -e "/home/vagrant/peta_expect_3.exp" ]; then
  echo "[ERROR] expect file not exists."
  exit 1
fi

# expand (expandfs.sh)
sudo lvresize -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv

#
# Install packages
#

# https://unix.stackexchange.com/questions/315502/how-to-disable-apt-daily-service-on-ubuntu-cloud-vm-image
echo 'stop apt.systemd.daily'
sudo systemctl stop apt-daily.service
sudo systemctl kill --kill-who=all apt-daily.service

# wait until `apt-get updated` has been killed
while ! (systemctl list-units --all apt-daily.service | egrep -q '(dead|failed)')
do
  sleep 1;
done

sudo apt-get -o Acquire::http::AllowRedirect=false update

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
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y python3 tofrodos iproute2 gawk xvfb gcc git make net-tools libncurses5-dev tftpd zlib1g-dev:i386 libssl-dev flex bison libselinux1 gnupg wget diffstat chrpath socat xterm autoconf libtool tar unzip texinfo zlib1g-dev gcc-multilib build-essential  libsdl1.2-dev libglib2.0-dev screen pax gzip libgtk2.0-0
sudo apt install -y libswt-gtk-4-jni
sudo apt install -y libsecret-1-0
sudo apt install -y graphviz
sudo apt install -y zip
# avoid stuck at 'Generating installed device list'
sudo apt install -y libncurses5 libtinfo5

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
if echo $_VIVADO_FILENAME | grep -q ".gz"; then
  tar zvxf $_VIVADO_FILENAME
else
  tar vxf $_VIVADO_FILENAME
fi
chown -R vagrant:vagrant ./$VIVADO_FILENAME
cd $VIVADO_FILENAME
# install required libraries
sudo ./installLibs.sh
# license agreement required
# choose configuration file
INST_LOCATION=""
if grep -q "Destination=.*/Xilinx" /mnt/xilinxinstaller/$CONFIG_FILENAME; then
  :
else
  INST_LOCATION="-l /tools/Xilinx"
fi

sudo ./xsetup --agree XilinxEULA,3rdPartyEULA --batch Install --config /mnt/xilinxinstaller/$CONFIG_FILENAME $INST_LOCATION
cd ..
rm -rf ./$VIVADO_FILENAME

if [ -d "/opt/Xilinx" ];then
  echo "source /opt/Xilinx/$VERSION_STR/Vivado/settings64.sh" >> /home/vagrant/.bash_profile
  echo "source /opt/Xilinx/$VERSION_STR/Vitis/settings64.sh" >> /home/vagrant/.bash_profile
elif [ -d "/tools/Xilinx" ];then
  echo "source /tools/Xilinx/$VERSION_STR/Vivado/settings64.sh" >> /home/vagrant/.bash_profile
  echo "source /tools/Xilinx/$VERSION_STR/Vitis/settings64.sh" >> /home/vagrant/.bash_profile
fi

if [ -e "/tools/Xilinx/$VERSION_STR/Vivado/scripts/installLibs.sh" ]; then
  sudo /tools/Xilinx/$VERSION_STR/Vivado/scripts/installLibs.sh
fi
if [ -e "/tools/Xilinx/$VERSION_STR/Vitis/scripts/installLibs.sh" ]; then
  sudo /tools/Xilinx/$VERSION_STR/Vitis/scripts/installLibs.sh
fi

chown vagrant:vagrant /home/vagrant/.bash_profile
chmod 644 /home/vagrant/.bash_profile


echo 'install Petalinux'

# install required libraries
chmod +x /mnt/xilinxinstaller/plnx-env-setup.sh
sudo /mnt/xilinxinstaller/plnx-env-setup.sh

if [ ! -e "/usr/bin/expect" ]; then
  echo "expect command not installed. you need to install petalinux manually."
  exit 1
fi
$_VERSION_STR=$VERSION_STR
while [ -n "$_VERSION_STR" ]; do
  pattern="petalinux*{$_VERSION_STR}*"
  file=$(find /mnt/xilinxinstaller -maxdepth 1 -type f -name "$pattern" -print -quit)
  if [ -n "$file" ]; then
    break
  fi
done
mkdir -p /home/vagrant/petalinux/$_VERSION_STR
sudo chown -R vagrant:vagrant /home/vagrant/petalinux
sudo chmod +x /mnt/xilinxinstaller/$PETALINUX_FILENAME
# license agreement required

sudo -u vagrant /usr/bin/expect -f /home/vagrant/peta_expect_3.exp /mnt/xilinxinstaller/$PETALINUX_FILENAME /home/vagrant/petalinux/$_VERSION_STR
source /home/vagrant/petalinux/$_VERSION_STR/settings.sh

echo "source /home/vagrant/petalinux/$_VERSION_STR/settings.sh" >> /home/vagrant/.bash_profile

sudo chown -R vagrant:vagrant /home/vagrant/petalinux
