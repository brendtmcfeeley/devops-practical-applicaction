output "client_ip" {
  value = data.external.client_info.result["ip"]
}

output "instance_ip" {
  value = aws_spot_instance_request.k3d.public_ip
}

output "instance_dns" {
  value = aws_spot_instance_request.k3d.public_dns
}

output "ami_name" {
  value = data.aws_ami.default.name
}

output "ami_id" {
  value = data.aws_ami.default.id
}

output "ami_user" {
  value = var.ami_instance_user
}

output "aws_user" {
  value = basename(data.aws_caller_identity.current.arn)
}

output "private_key_path" {
  value = var.private_key_path
}