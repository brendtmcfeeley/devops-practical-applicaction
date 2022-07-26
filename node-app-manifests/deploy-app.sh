case $1 in
  dev|test|prod)
    ENV="$1"
    echo "Set environment to ${ENV}"
  ;;
  "")
    echo "Missing environment" >&2
    exit 1
  ;;
  *)
    echo "Unknown environment \"$1\"" >&2
    exit 1
  ;;
esac

# Create the namespace first
kubectl apply -f base/resources/namespace.yaml

# If you don't have bitnami yet
helm repo add bitnami https://charts.bitnami.com/bitnami

# Install MongoDB
helm install mongodb bitnami/mongodb -n swimlane

# Setup non-admin non-root db and user
k apply -k base/mongo-init

# Install app onto k8s
kubectl apply -k env/${ENV}