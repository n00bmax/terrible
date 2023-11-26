# Ubuntu Server jammy
# ---
# Packer Template to create an Ubuntu Server (jammy) on Proxmox
packer {
  required_plugins {
    proxmox = {
      version = " >= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }

}

# Resource Definiation for the VM Template
source "proxmox-iso" "ubuntu-server-jammy" {

  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api_config.url}"
  username    = "${var.proxmox_api_config.token_id}"
  token       = "${var.proxmox_api_config.token_secret}"
  # (Optional) Skip TLS Verification
  insecure_skip_tls_verify = true

  # VM General Settings
  node                 = "UditSuperServer"
  vm_id                = "${var.template_config.vmid}"
  vm_name              = "ubuntu-server-jammy"
  template_description = "Ubuntu Server jammy Image"

  # VM OS Settings
  # (Option 1) Local ISO File
  iso_file = "local:iso/ubuntu-22.04.2-live-server-amd64.iso"
  # - or -
  # (Option 2) Download ISO
  //   iso_url          = "https://releases.ubuntu.com/22.04/ubuntu-22.04.3-live-server-amd64.iso"
  //   iso_checksum     = "a4acfda10b18da50e2ec50ccaf860d7f20b389df8765611142305c0e911d16fd"
  iso_storage_pool = "local"
  unmount_iso      = true

  # VM System Settings
  qemu_agent = true
  //   cpu = "host"
  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-single"

  disks {
    disk_size    = "10G"
    format       = "raw"
    storage_pool = "local-zfs"
    type         = "scsi"
  }

  # VM CPU Settings
  cores = "2"

  # VM Memory Settings
  memory = "8192"

  # VM Network Settings
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = false
  }

  # VM Cloud-Init Settings
  cloud_init              = true
  cloud_init_storage_pool = "local-zfs"

  # PACKER Boot Commands
  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud ---<wait>",
    "<f10><wait>"
  ]
  boot      = "c"
  boot_wait = "5s"

  # PACKER Autoinstall Settings
  //   http_directory = "data"
  //   http_content   = local.data_source_content
  //   http_interface = ""
  additional_iso_files {
    cd_content       = local.data_source_content
    cd_label         = "cidata"
    iso_storage_pool = "local"
  }


  ssh_username         = "udit"
  ssh_private_key_file = "~/.ssh/id_rsa"

  # Raise the timeout, when installation takes longer
  ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {

  name    = "ubuntu-server-jammy"
  sources = ["source.proxmox-iso.ubuntu-server-jammy"]

  provisioner "ansible" {
    playbook_file = "${path.root}/../ansible/k8s-init.yml"
  }
  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync"
    ]
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
  provisioner "file" {
    source      = "${path.root}/files/${var.template_config.file_name}"
    destination = "/tmp/${var.template_config.file_name}"
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
  provisioner "shell" {
    inline = ["sudo cp /tmp/${var.template_config.file_name} /etc/cloud/cloud.cfg.d/${var.template_config.file_name}"]
  }

  # Add additional provisioning scripts here
  # ...
}