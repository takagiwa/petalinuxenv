variable "boot_wait" {
    default = "5s"
}
variable "cpus" {
    default = "1"
}
variable "disk_size" {
    default = "65536"
}
variable "virtualbox_guest_os_type" {
    default = "Ubuntu_64"
}
variable "headless" {
    default = "false"
}
variable "http_directory" {
    default = "./http"
}
variable "iso_url" {
    default = "http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"
}
variable "iso_checksum" {
    default = "sha256:d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
}
variable "memory" {
    default = "512"
}
variable "build_directory" {
    default = "./build"
}
variable "ssh_timeout" {
    default = "45m"
}
variable "ssh_username" {
    default = "vagrant"
}
variable "ssh_password" {
    default = "vagrant"
}
variable "vm_name" {
    default = "ubuntu2004"
}
variable "scripts" {
    default = "scripts/setkey.sh"
}

variable "preseed" {
    default = "preseed/url=http://<wait><wait>{{ .HTTPIP }}:{{ .HTTPPort }}<wait><wait>/ubuntu1x.cfg"
}

variable "boot_command" {
    default = "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/"
}

# refer to https://github.com/boxcutter/ubuntu/blob/master/ubuntu.json

variable "boot_command_prefix" {
    default = "<enter><enter><f6><esc><wait>"
}

source "virtualbox-iso" "ubuntu" {

    boot_command = [
      "<wait><esc><esc><esc><wait>",
      "<enter><wait>",
      "/casper<wait>/vmlinuz <wait>",
      "root=<wait>/dev/sr0 <wait>",
      "initrd=<wait>/casper<wait>/initrd <wait>",
      "autoinstall <wait>",
      "ds=nocloud-net;<wait>s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/<wait>",
    "<enter>"
    ]

    boot_wait              = var.boot_wait
    cpus                   = var.cpus
    disk_size              = var.disk_size
    guest_os_type          = "Ubuntu_64"
    hard_drive_interface   = "sata"
    headless               = var.headless
    http_directory         = var.http_directory
    iso_url                = var.iso_url
    iso_checksum           = var.iso_checksum
    memory                 = var.memory
    output_directory       = "${var.build_directory}/packer-virtualbox"
    shutdown_command       = "echo '${var.ssh_username}' | sudo -S shutdown -P now"
    ssh_timeout            = var.ssh_timeout
    ssh_username           = var.ssh_username
    ssh_password           = var.ssh_password
    vm_name                = var.vm_name
    #guest_additions_path   = "/home/vagrant/VBoxGuestAdditions_{{.Version}}.iso"
    post_shutdown_delay    = "1m"
    ssh_wait_timeout       = var.ssh_timeout
    ssh_handshake_attempts = "200"
    #guest_additions_mode   = "attach"

    vboxmanage             = [
      ["modifyvm", "{{.Name}}", "--nic2", "hostonly"],
      ["modifyvm", "{{.Name}}", "--hostonlyadapter2", "VirtualBox Host-Only Ethernet Adapter"],
      #["modifyvm", "{{.Name}}", "--macaddress2", "XXXXXXXXXXXX"],
    ]
}

build {
    sources = [
      "sources.virtualbox-iso.ubuntu"
    ]
    provisioner "shell" {
      execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -E -S bash '{{.Path}}' '${var.ssh_username}'"
      scripts = [
        "scripts/expandfs.sh",
        "scripts/add2sudoer.sh",
        "scripts/setkey.sh",
        "scripts/vboxguest.sh"
      ]
    }
    post-processors {  
      post-processor "artifice" {
        files = [
          "build/packer-virtualbox/${var.vm_name}-disk001.vmdk",
          "build/packer-virtualbox/${var.vm_name}.ovf"
        ]
      }
      post-processor "vagrant" {
        keep_input_artifact = true
        provider_override   = "virtualbox"
      }  
    }
}

