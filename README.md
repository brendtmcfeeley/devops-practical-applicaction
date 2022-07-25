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

scp -i $(terraform output -raw private_key_path) $(terraform output -raw ami_user)@$(terraform output -raw instance_ip):.kube/config config
sed -i '' "s|0.0.0.0|$(terraform output -raw instance_ip)|g" config
mv config ~/.kube/

install namespace
install helm chart
install via kube