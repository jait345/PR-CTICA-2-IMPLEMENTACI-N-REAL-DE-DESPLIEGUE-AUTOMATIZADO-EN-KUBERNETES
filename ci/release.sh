#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=${NAMESPACE:-production}
IMAGE=${IMAGE:-ghcr.io/${GITHUB_REPOSITORY}:${IMAGE_TAG:-latest}}

echo "Updating image to ${IMAGE} in namespace ${NAMESPACE}..."
kubectl -n ${NAMESPACE} set image deployment/sample-app sample-app=${IMAGE} --record
kubectl -n ${NAMESPACE} rollout status deployment/sample-app --timeout=120s

echo "Release applied."
