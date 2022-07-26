# DevOps Practical Application Deployment

## What is this?

This is a demonstration deploy of a Node application using Kubernetes, Helm, Terraform, Ansible, Helm, and Packer.

This project is broken down into two separate deployment methods

1) Local k3d install
2) k3d install on AWS

# Pre-requisites

Please install all of the folloiwng (MacOS) using the package manager of your choice. HomeBrew reccomended.

```
k3d
kubectl
helm
kustomize
packer
ansible
awscli
docker

Example : brew install k3d kubectl helm kustomize packer ansible awscli
```

# Kubernetes Install

## Local k3d Install

First of all.. what is [k3d](https://k3d.io/v5.4.4/)?

k3d is a lightweight wrapper of k3s! It deploys k8s nodes as docker images (so please make sure docker is running!) to help save on deployment cost and size.

* Note : This method requires a good chunk of free RAM. If running locally, please aim to have at least 4 GB available.
* But for maximum availability, see AWS deployment below

```
k3d create cluster dev-cluster
```

That's it! Use `kubectl get nodes -A` to see your nodes running.

## AWS k3d Install

We can install k3d on a EC2 instance so we can perform all k8s functions (with main and worker nodes) on a singular instance. This saves a lot of money and resources for development costs. Almost all work can be mimiced to an EKS solution.

The `k3d-aws-env` installs everything you need to deploy a TF instance. This includes, VPCs, appropriate CIDR blocks, subnets, IGWs, and security groups.

The main code is open-source of DoD Platform1. https://repo1.dso.mil/platform-one/big-bang/terraform-modules/k3d-dev-env although I have created my own fork of this and modified it a bunch for personal use.

There is more detailed documentation in the k3d-aws-env/ folder.

Please make sure to pay attention to certain fields that need to be changed for your specific region (and a singular AWS account ID) - all outlined in the k3d-aws-env README

TL;DR of it
* Find Ubuntu 20.04 AMI ID (only if outside of us-west-1) and build the k3d ami via packer in `k3d-aws-env/packer`
```
packer build -var-file=../terraform.tfvars.json k3d-dev-env.pkr.hcl
```
* Apply terraform in `k3d-dev-env/`
```
terraform apply
```
* Grab the kubeconfig from the ec2 instance in `k3d-dev-env/`
```
scp -i $(terraform output -raw private_key_path) $(terraform output -raw ami_user)@$(terraform output -raw instance_ip):.kube/config config
sed -i '' "s|0.0.0.0|$(terraform output -raw instance_ip)|g" config
mv config ~/.kube/
```

# Application Install

All application install and manifests are located in `node-app-manifests/`

The main application is located in `base/`, this is where the application level definitions are.

The `env/` folder is used to mimic a working environment and separate different values we can apply when working in a production setting.

We make use of kustomize so we don't need to aggregate 20+ kubernetes files all at once. We can call kustomize on a couple of kustomization.yaml files and deploy most of our resources.

## Initial Install Script

We need to configure a MongoDB instance for the app to use. For this we use a BitNami MongoDB helm chart and configured it to create a separate DB and user so we don't need to use the root user and password.

Please ensure your k3d cluster is up and running.

```
./configure-mongo.sh
```

## Deploying the application

To deploy the application, ensure the `mongodb` batch job has completed. Once it has you can freely deploy/re-deploy the application as needed.

```
kubectl apply -k env/dev
```

Replace /dev as needed for different environments, but currently only dev is set up with the correct tag.