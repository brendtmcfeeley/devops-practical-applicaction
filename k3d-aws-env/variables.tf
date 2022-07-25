#
# SSH arguments
#

variable "private_key_path" {
  description = "Local path to the SSH private key to authenticate with"
  type        = string
}

variable "public_key_path" {
  description = "Local path to the SSH public key to authenticate with"
  type        = string
}

#
# kubeconfig arguments
#

variable "download_kubeconfig" {
  description = "Optionally download and overwrite a local kubeconfig file"
  type        = bool
}

variable "kubeconfig_path" {
  description = "Local path to the kubeconfig file to overwrite"
  type        = string
}

#
# k3d arguments
#

variable "k3d_cluster_name" {
  description = "Desired cluster name for k3d to use"
  type        = string
}

variable "k3d_args" {
  description = "Desired k3d args to pass in"
  type        = string
}

variable "k3d_servers" {
  description = "Desired number of k3d servers to spawn"
  type        = number
}

variable "k3d_agents" {
  description = "Desired number of k3d agents to spawn"
  type        = number
}

variable "k3d_api_port" {
  description = "Desired API server port for k3d to serve on"
  type        = number
}

variable "k3d_upload_images" {
  description = "Optionally load images from tar into k3d cluster"
  type        = bool
}

variable "k3d_images_tarball" {
  description = "Local path to the images tarball (tar.gz) to load into k3d"
  type        = string
}

##
# Variables that are not intended to be changed during developer usage.
# If need be, these can be overridden for more specific technical usage.
# These variables cannot be used in any ansible logic.
# Default values must be specified here.
##

#
# AWS arguments
#

variable "aws_region" {
  description = "AWS region to launch servers"
  default     = "us-west-1"
  type        = string
}

variable "aws_instance_type" {
  description = "Desired AWS instance type"
  default     = "t2.xlarge"
  type        = string
}

variable "aws_root_block_size" {
  description = "Desired AWS instance root block size"
  default     = 60
  type        = number
}

variable "aws_tag_name" {
  description = "Desired tag name to use for AWS resources"
  default     = "k3d-dev-env"
  type        = string
}

variable "aws_ingress_all" {
  description = "Optionally allow ingress from anywhere"
  default     = false
  type        = bool
}

#
# AMI arguments
#

variable "ami_owner_id" {
  description = "Owner ID for use in the AMI filter"
  # AMI ID Will change based on the packer image you build
  default     = ["688168144979"]
  type        = list(string)
}

variable "ami_filter_name" {
  description = "Name to filter when picking an AMI"
  default     = "k3d-dev-env"
  type        = string
}

variable "ami_root_device_type" {
  description = "AMI root device type to filter on"
  default     = ["ebs"]
  type        = list(string)
}

variable "ami_virtualization_type" {
  description = "AMI virtualization type to filter on"
  default     = ["hvm"]
  type        = list(string)
}

variable "ami_instance_user" {
  description = "Default AWS instance username"
  default     = "ubuntu"
  type        = string
}

#
# ansible cli arguments
#

variable "ansible_playbook_path" {
  description = "Default ansible playbook path"
  default     = "ansible/k3d.yaml"
  type        = string
}

variable "ansible_host_key_checking" {
  description = "Default ansible host key checking value"
  default     = false
  type        = bool
}

variable "ansible_ssh_retries" {
  description = "Default ansible SSH retries value"
  default     = 10
  type        = number
}

variable "ansible_pre_args" {
  description = "Additional CLI arguments to pass before ansible-playbook command (Ex: ANSIBLE_SSH_RETIRES)"
  default     = ""
  type        = string
}

variable "ansible_post_args" {
  description = "Additional CLI arguments to pass directly after ansible-playbook command (Ex: --extra-vars)"
  default     = ""
  type        = string
}