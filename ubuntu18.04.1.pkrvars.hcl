boot_command_prefix="<enter><wait><esc><wait><enter><wait>"
boot_command="/install/vmlinuz<wait> file=/cdrom/preseed/ubuntu-server.seed vga=788 initrd=/install/initrd.gz auto-install/enable=true debconf/priority=critical"
preseed=" auto-install/enable=true preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu18.04.1.cfg"
vm_name="ubuntu18041"
iso_url="file://f:/iso/ubuntu-18.04.1-server-amd64.iso"
iso_checksum="md5:e8264fa4c417216f4304079bd94f895e"
disk_size="10000"
memory="1024"
boot_wait="10s"
ssh_timeout="120m"
