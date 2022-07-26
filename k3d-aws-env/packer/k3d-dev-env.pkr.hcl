locals {
    release_version = yamldecode(file("../release.yaml"))["version"]
    region          = "us-west-1"
}

source "amazon-ebs" "default" {
  ami_description       = "Base AMI for the k3d-dev-env terraform module"
  ami_name              = "k3d-dev-env-${local.release_version}"
  force_delete_snapshot = "true"
  force_deregister      = "true"
  instance_type         = "t2.medium"
  region                = local.region
  ssh_username          = "ubuntu"
   # This will change if you are building it for your own AWS
  subnet_id             = "subnet-051f0a826bfe193e9"
  associate_public_ip_address = true
  encrypt_boot          = false
  # Source packer AMI depends on what region you're in
  # Default AWS marketplace Ubuntu 20.04 x86 AMI
  source_ami            = "ami-01154c8b2e9a14885"

  # source_ami_filter {
  #   filters = {
  #     name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
  #     root-device-type    = "ebs"
  #     virtualization-type = "hvm"
  #   }
  #   most_recent = true
  #   owners      = ["099720109477"]
  # }

  tags = {
    Base_AMI_Name = "{{ .SourceAMIName }}"
    Builder       = "https://www.packer.io/"
    OS_Version    = "ubuntu-focal-20.04-amd64-server"
    Release       = "${local.release_version}"
  }
}

build {
  sources = ["source.amazon-ebs.default"]

  provisioner "shell" {
    script = "scripts/provision.sh"
    expect_disconnect = true
  }

  post-processor "manifest" {
    output = "k3d-dev-env.manifest.json"
    strip_path = true
  }
}