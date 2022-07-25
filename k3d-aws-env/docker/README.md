# k3d-dev-env.docker

# Building

## Dockerfile.k3d-dev-env

```
docker build -t registry.dso.mil/platform-one/big-bang/terraform-modules/k3d-dev-env:latest -f Dockerfile.k3d-dev-env .
docker push registry.dso.mil/platform-one/big-bang/terraform-modules/k3d-dev-env:latest
```

# Notes

Please do not override the default images that already exist.