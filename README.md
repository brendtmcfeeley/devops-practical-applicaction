# devops-practical

Pre-reqs

k3d
docker
kubectl

k3d install

```
brew install k3d
```

kustomize build .
k apply -k .

install mongo via helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongodb bitnami/mongodb -n swimlane
https://bitnami.com/stack/mongodb/helm