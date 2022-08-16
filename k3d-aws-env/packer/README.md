# k3d-dev-env.packer

A packer module to generate AMI images for use with the `k3d-dev-env` terraform module.

## Run Packer Build

```
packer build -var-file=../terraform.tfvars.json k3d-dev-env.pkr.hcl
```
