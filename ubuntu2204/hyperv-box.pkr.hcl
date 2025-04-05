packer {
  required_plugins {
    hyperv = {
      version = ">= 1.1.4"
      source  = "github.com/hashicorp/hyperv"
    }
  }
}

source "hyperv-iso" "ubuntu" {
  boot_command = [
    "c",
    "linux /casper/vmlinuz autoinstall net.ifnames=0 biosdevname=0 ",
    "ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' --- <enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]
  headless              = true
  boot_wait            = "5s"
  http_directory        = "http"
  communicator         = "ssh"
  cpus                 = "2"
  memory           = "4096"
  disk_size            = "20480"
  enable_secure_boot   = false
  generation           = 2
  guest_additions_mode = "disable"
  iso_checksum     = "9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
  iso_url          = "https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
  output_directory = "./output/ubuntu/"
  shutdown_command = "echo 'vagrant' | sudo -S -E shutdown -P now"
  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  ssh_timeout      = "4h"
  switch_name      = "External Switch"
  vm_name          = "demo"
}

build {
  sources = ["source.hyperv-iso.ubuntu"]
  
  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "./build/${source.type}-ubuntu.box"
  }
}