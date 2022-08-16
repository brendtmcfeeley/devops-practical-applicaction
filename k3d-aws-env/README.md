# k3d-dev-env

Deploy a multi-node k8s cluster on an AWS EC2 instance using terraform, ansible, and k3d.

# Requirements

## Supported Systems

Other systems may be used, but documentation is written for the following:
* MacOS

## Install Packages

Install the required packages (MacOS):

```
brew install awscli terraform ansible kubectl packer
```

## AWS Configuration

**Note**: You will need to obtain access to a supported AWS account and region to use this project.

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

# Pre-req file changes

Some AMIs are us-west-1 specific, please pay attention if you are in a separate AWS region!

* packer/k3d-dev-env.hcl
    - Line 3 : region          = "us-west-1"
        - The region will need to change if you use another region
    - Line 20 : ami-01154c8b2e9a14885
        - This is the Ubuntu 20.04 AWS ami for us-west-1. Go to the AWS marketplace and grab the 20.04 AMI ID if you wish to change this
* variables.tf
    - Line 81 : default     = "us-west-1"
        - This will need to change if you use another region
    - Line 116 : default     = [""]
        - This will be your AWS account id

If you wish to use .envrc for environment control

```
cp .envrc.example .envrc
direnv allow
```

# Packer

To build the k3d AMI image, follow the README in the `packer` directory

**You will need to build the k3d image via packer if you want to deploy via AWS**

# Running

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

# Verifying

Check to see if your cluster is up and running:

```
kubectl get nodes -A
```

# Destroying

Please make sure to destroy your resources when not in use:

```
terraform destroy --auto-approve
```
