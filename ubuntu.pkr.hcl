
variable "boot_wait" {
    default = "5s"
}

variable "http_directory" {
    default = "./http"
}

variable "build_directory" {
    default = "./build"
}

variable "provider_name" {
    default = "virtualbox"
}

variable "ssh_timeout" {
    default = "45m"
}

variable "preseed" {
    default = ""
}

variable "boot_command" {
    default = "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/"
}

# refer to https://github.com/boxcutter/ubuntu/blob/master/ubuntu.json

variable "boot_command_prefix" {
    default = "<enter><enter><f6><esc><wait>"
}

variable "cleanup_pause" {
    default = ""
}

variable "cpus" {
    default = "1"
}

variable "custom_script" {
    default = "custom-script.sh"
}

variable "desktop" {
    default = "false"
}

variable "disk_size" {
    default = "65536"
}

variable "ftp_proxy" {
    # {{env `ftp_proxy`}}
    default = ""
}

variable "headless" {
    default = "false"
}

variable "http_proxy" {
    # {{env `http_proxy`}}
    default = ""
}

variable "https_proxy" {
    # {{env `https_proxy`}}
    default = ""
}

variable "install_vagrant_key" {
    default = "true"
}

variable "iso_checksum" {
    default = "sha256:d1f2bf834bbe9bb43faf16f9be992a6f3935e65be0edece1dee2aa6eb1767423"
}

variable "iso_name" {
    default = "ubuntu-20.04.1-live-server-amd64.iso"
}

variable "iso_path" {
    default = "/Volumes/Storage/software/ubuntu"
}

variable "iso_url" {
    default = "http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"
}

variable "memory" {
    default = "512"
}

variable "no_proxy" {
    # {{env `no_proxy`}}
    default = ""
}

variable "parallels_guest_os_type" {
    default = "ubuntu"
}

variable "rsync_proxy" {
    # {{env `rsync_proxy`}}
    default = ""
}

variable "hostname" {
    default = "vagrant"
}

variable "ssh_fullname" {
    default = "vagrant"
}

variable "ssh_password" {
    default = "vagrant"
}

variable "ssh_username" {
    default = "vagrant"
}

variable "update" {
    default = "false"
}

variable "vagrantfile_template" {
    default = ""
}

variable "version" {
    default = "0.1.0"
}

variable "virtualbox_guest_os_type" {
    default = "Ubuntu_64"
}

variable "vm_name" {
    default = "ubuntu2004"
}

variable "vmware_guest_os_type" {
    default = "ubuntu-64"
}

source "virtualbox-iso" "ubuntu" {

    boot_command = [
        "${var.boot_command_prefix}",
        "${var.boot_command}",
        " ${var.preseed}",
        " --- <wait>",
        " <enter><wait>"
    ]

    #boot_command = [
    #    "<enter><wait>",
    #    "<esc><wait>",
    #    "<enter><wait>",
    #    "/install/vmlinuz<wait>",
    #    " file=/cdrom/preseed/ubuntu-server.seed vga=788 initrd=/install/initrd.gz",
    #    " auto-install/enable=true",
    #    " debconf/priority=critical",
    #    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu18.04.1.cfg",
    #    " --- <wait>",
    #    "<enter><wait>"
    #]

    boot_wait              = var.boot_wait
    cpus                   = var.cpus
    disk_size              = var.disk_size
    guest_os_type          = var.virtualbox_guest_os_type
    hard_drive_interface   = "sata"
    headless               = var.headless
    http_directory         = var.http_directory
    iso_url                = var.iso_url
    iso_checksum           = var.iso_checksum
    memory                 = var.memory
    output_directory       = "${var.build_directory}/packer-${var.provider_name}"
    shutdown_command       = "echo '${var.ssh_username}' | sudo -S shutdown -P now"
    ssh_timeout            = var.ssh_timeout
    ssh_username           = var.ssh_username
    ssh_password           = var.ssh_password
    vm_name                = var.vm_name
    guest_additions_path   = "VBoxGuestAdditions_{{.Version}}.iso"
    post_shutdown_delay    = "1m"
    ssh_wait_timeout       = var.ssh_timeout
    ssh_handshake_attempts = "200"
}

build {
    sources = [
      "sources.virtualbox-iso.ubuntu"
    ]
    post-processors {  
      post-processor "artifice" {
        files = [
          "build/packer-virtualbox/ubuntu18041-disk001.vmdk",
          "build/packer-virtualbox/ubuntu18041.ovf"
        ]
      }
      post-processor "vagrant" {
        keep_input_artifact = true
        provider_override   = "virtualbox"
      }  
    }
}

