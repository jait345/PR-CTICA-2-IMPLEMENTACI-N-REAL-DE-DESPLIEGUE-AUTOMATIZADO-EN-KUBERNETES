#!/usr/bin/env bash
set -euo pipefail

# Config
CLUSTER_NAME="practice2-kind"
NAMESPACE="production"
INGRESS_RELEASE_NAME="ingress-nginx"

# Helper: check commands
command -v kind >/dev/null 2>&1 || {
  echo "kind not found. Installing kind..."
  curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
}

command -v kubectl >/dev/null 2>&1 || {
  echo "kubectl not found. Installing..."
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/kubectl
}

command -v helm >/dev/null 2>&1 || {
  echo "helm not found. Installing..."
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
}

# Create cluster if not exists
if kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  echo "Kind cluster ${CLUSTER_NAME} already exists."
else
  echo "Creating kind cluster ${CLUSTER_NAME}..."
  kind create cluster --name "${CLUSTER_NAME}" --wait 60s
fi

# Ensure kubeconfig context
kubectl cluster-info --context "kind-${CLUSTER_NAME}"

# Create namespace if not exists
if kubectl get namespace "${NAMESPACE}" >/dev/null 2>&1; then
  echo "Namespace ${NAMESPACE} exists."
else
  kubectl create namespace "${NAMESPACE}"
fi

# Install ingress-nginx via helm if not installed
if helm -n ingress-nginx list | grep -q "${INGRESS_RELEASE_NAME}"; then
  echo "ingress-nginx already installed."
else
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update
  kubectl create namespace ingress-nginx --dry-run=client -o yaml | kubectl apply -f -
  helm install "${INGRESS_RELEASE_NAME}" ingress-nginx/ingress-nginx --namespace ingress-nginx --wait
fi

echo "Provision complete. Namespace: ${NAMESPACE}. Ingress installed in ingress-nginx namespace."
