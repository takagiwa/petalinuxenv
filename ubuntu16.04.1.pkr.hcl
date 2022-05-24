# E:\petalinux\petalinuxenv>d:\packer build --force -var-file=ubuntu16.04.1.pkrvars.hcl ubuntu16.04.1.pkr.hcl
# https://lab.nexedi.com/nexedi/slapos.package/commit/2f9bead0ac50fbfa34bc40cae8c05ea82612596a

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
variable "iso_url_dos" {
    default = "http://releases.ubuntu.com/20.04/ubuntu-20.04.2-live-server-amd64.iso"
}

source "virtualbox-iso" "ubuntu" {

    boot_command = [
        #"<enter><wait><esc><wait><enter><wait>",
        #"/install/vmlinuz\\<enter>",
        #" file=/cdrom/preseed/ubuntu-server.seed vga=788 initrd=/install/initrd.gz\\<enter>",
        #" auto-install/enable=true\\<enter>",
        #" debconf/priority=critical\\<enter>",
        #" preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu16.04.1.cfg ---<wait>",
        #"<enter><wait>"
        #"<enter><wait><esc><wait><enter><wait>/install/vmlinuz file=/cdrom/preseed/ubuntu-server.seed vga=788 initrd=/install/initrd.gz auto-install/enable=true debconf/priority=critical preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu16.04.1.cfg ---<wait><enter><wait>"
        #"<enter><wait><esc><wait><enter><wait>/install/vmlinuz file=/cdrom/preseed/ubuntu-server.seed auto-install/enable=true debconf/priority=critical preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu16.04.1.cfg vga=788 initrd=/install/initrd.gz ---<wait><enter><wait>"
        "<enter><wait>",
        "<f6><esc>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><wait>",
        "<bs><bs><bs>",
        #"/install/vmlinuz <wait>",
        "file=/cdrom/preseed/ubuntu-server.seed <wait><wait>auto-install/enable=true <wait><wait>debconf/priority=critical <wait><wait>preseed/url=http://<wait><wait>{{ .HTTPIP }}:{{ .HTTPPort }}<wait><wait>/ubuntu16.04.1.cfg <wait><wait>vga=788 <wait><wait>initrd=/install/initrd.gz ---<wait><enter><wait>"
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
    guest_additions_path   = "VBoxGuestAdditions_{{.Version}}.iso"
    post_shutdown_delay    = "1m"
    ssh_wait_timeout       = var.ssh_timeout
    ssh_handshake_attempts = "200"
}

build {
    sources = [
      "sources.virtualbox-iso.ubuntu"
    ]
    provisioner "file" {
      source = var.iso_url_dos
      destination = "/home/${var.ssh_username}/ubuntu.iso"
    }
    provisioner "shell" {
      execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
      scripts = [
        "scripts/add2sudoer.sh",
        "scripts/setkey.sh"
      ]
    }
    post-processors {  
      post-processor "artifice" {
        files = [
          "build/packer-virtualbox/ubuntu16041b-disk001.vmdk",
          "build/packer-virtualbox/ubuntu16041b.ovf"
        ]
      }
      post-processor "vagrant" {
        keep_input_artifact = true
        provider_override   = "virtualbox"
      }  
    }
}
