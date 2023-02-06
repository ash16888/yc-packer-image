# YC custom VM Image based on Ubuntu 20.04 LTS
# Yandex Packer provisioner docs:
# https://www.packer.io/docs/builders/yandex
##
variable "YC_TOKEN" {
  type = string
  default = env("YC_TOKEN")
}

variable "FOLDER_ID" {
  type = string
  default = env("FOLDER_ID")
}

variable "SUBNET_ID" {
  type = string
  default = env("SUBNET_ID")
}

locals {
  DATE = formatdate("YYYY-MM-DD-hhmm", timestamp())
 }

source "yandex" "yc-pkr" {
  token               = "${var.YC_TOKEN}"
  folder_id           = "${var.FOLDER_ID}"
  source_image_family = "ubuntu-2204-lts"
  ssh_username        = "ubuntu"
  use_ipv4_nat        = "true"
  image_description   = "Yandex Cloud Ubuntu image"
  image_family        = "pkr-images"
  image_name          = "pkr-${local.DATE}"
  subnet_id           = "${var.SUBNET_ID}"
  disk_type           = "network-hdd"
  zone                = "ru-central1-a"
}

build {
  sources = ["source.yandex.yc-pkr"]


  provisioner "file" {
    source      = "node_exporter/node_exporter.service"
    destination = "/tmp/node_exporter.service"
  }

  # Execute setup script  
  provisioner "shell" {
    script = "setup.sh" 
  }
}
