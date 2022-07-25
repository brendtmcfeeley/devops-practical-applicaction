# obtain module release version
locals {
  release_version = yamldecode(file("release.yaml"))["version"]
}

# obtain the current aws caller identity
data "aws_caller_identity" "current" {}

# obtain the current client public ip address for vpc use
data "external" "client_info" {
  program = ["/bin/bash", "${path.module}/scripts/client_info.sh"]
}

# obtain a valid aws ami to use for deployment
data "aws_ami" "default" {
  owners      = var.ami_owner_id
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_filter_name}-${local.release_version}"]
  }

  filter {
    name   = "root-device-type"
    values = var.ami_root_device_type
  }

  filter {
    name   = "virtualization-type"
    values = var.ami_virtualization_type
  }
}