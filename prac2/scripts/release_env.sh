#!/usr/bin/env bash
set -euo pipefail
IMAGE_TAG=${IMAGE_TAG:-latest}
NAMESPACE=${NAMESPACE:-release}
OUT_DIR="practicas cicd/prac2/out/${NAMESPACE}"
mkdir -p "$OUT_DIR"
cp "practicas cicd/prac2/k8s/"*.yaml "$OUT_DIR"/
sed -i.bak "s|ghcr.io/jait345/marketsenseai-backend:latest|ghcr.io/${REPO_OWNER}/marketsenseai-backend:${IMAGE_TAG}|" "$OUT_DIR/deployment.yaml"
kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -
kubectl -n "$NAMESPACE" apply -f "$OUT_DIR/secret.yaml"
