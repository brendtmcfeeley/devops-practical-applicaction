# Create the namespace first
kubectl apply -f base/resources/namespace.yaml

# If you don't have bitnami yet
helm repo add bitnami https://charts.bitnami.com/bitnami

# Install MongoDB
helm install mongodb bitnami/mongodb -n swimlane

# Setup non-admin non-root db and user
kubectl apply -k base/mongo-init