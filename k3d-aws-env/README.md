# k3d-dev-env

Deploy a multi-node k8s cluster on an AWS EC2 instance using terraform, ansible, and k3d; primarily for deploying the bigbang baseline.

# Requirements

## Supported Systems

Other systems may be used, but documentation is written for the following:
* MacOS

## Install Packages

Install the required packages (MacOS):

```
brew install awscli terraform ansible kubectl
```

If you are planning on building the required k3d AMI

```
brew install packer
```

## AWS Configuration

**Note**: You will need to obtain access to a supported AWS account and region to use this project.

All required AWS resources are stored in the BigBang AWS account, and shared to several other supported accounts and regions.

Using unlisted AWS accounts or regions is currently not supported.

Configure your AWS credentials and region:
* Make sure this region equals the `aws_region` variable.

```
aws configure
```

## SSH Key

Make sure to generate an SSH key:
* If you use something other than `<home_full_path>/.ssh/id_rsa`, make sure to update the `private_key_path` and the `public_key_path` variables.

```
ssh-keygen
```

## Variable File Configuration

Set up (and optionally modify) your `terraform.tfvars.json` file:

```
cp terraform.tfvars.json.example terraform.tfvars.json
```

# Initialization

Initialize the terraform module, this only needs to be done once:

```
terraform init
```

# Variables / Customization

All custom variables must be defined in the `terraform.tfvars.json` file.

This file must exist, and is the only tfvars file type allowed.

**No other method of passing variables is supported.**

This is due to limitations with passing terraform variables to ansible.

# Running

Steps that will be done after application:
* A security group will be created that only allows your IP ingress.
* Your SSH key will be created and linked as a new AWS keypair.
* An EC2 instance is spawned from the `k3d-dev-env` AMI.
* A k3d cluster will be created according to set requirements.
* (Optional) Your local kubeconfig file will be overwritten.
* Output information will be populated for debugging use.

Plan the terraform module:

```
terraform plan
```

Apply the terraform module:

```
terraform apply
```

# Grabbing kubeconfig

Several methods of grabbing the kubeconfig exist, the easiest is to scp it

This method replaces your kubeconfig, if you want to add it to an existing kubeconfig, use the [KUBECONFIG](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#set-the-kubeconfig-environment-variable) variable

```
scp -i $(terraform output -raw private_key_path) $(terraform output -raw ami_user)@$(terraform output -raw instance_ip):.kube/config config
sed -i '' "s|0.0.0.0|$(terraform output -raw instance_ip)|g" config
mv config ~/.kube/
```

# Proxying

Several methods of ingress proxying can be used, here is one example:

```
ssh -i $(terraform output -raw private_key_path) $(terraform output -raw ami_user)@$(terraform output -raw instance_ip)
```

# Verifying

Check to see if your cluster is up and running:

```
kubectl get nodes -o wide
```

# Destroying

Please make sure to destroy your resources when not in use:

```
terraform destroy --auto-approve
```

# Packer

If you want to build the k3d AMI image, follow the README in the `packer` directory
