# k3d-dev-env.packer

A packer module to generate AMI images for use with the `k3d-dev-env` terraform module.

# Notes

**If you are not a maintainer of this project, do not build any AMI images.**

You are very likely to overwrite existing images and break the release process.

# Cheat Sheet

## List Rogue Build AMI's

```
aws ec2 describe-images --filters "Name=name,Values=k3d-dev-env-*-*" | jq -r ".Images[] | { name: .Name } | .name"
aws ec2 describe-images --filters "Name=name,Values=k3d-dev-env-*-*" | jq -r ".Images[] | { id: .ImageId } | .id"
```

## Delete Rogue Build AMI's

```
for id in $(aws ec2 describe-images --filters "Name=name,Values=k3d-dev-env-*-*" | jq -r ".Images[] | { id: .ImageId } | .id"); do
  echo "Deregistering $id"
  aws ec2 deregister-image --image-id $id
done
```

## Run Packer Build

```
packer build -var-file=../terraform.tfvars.json k3d-dev-env.pkr.hcl
```