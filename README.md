# Practica 2 - Despliegue Automatizado en Kubernetes

## Qué incluye
- IaC para provisionar un clúster *kind* (infra/terraform).
- Manifests k8s (k8s/).
- Pipeline GitHub Actions (.github/workflows/ci.yml).
- Scripts de release y rollback (ci/).
- Tests (tests/).

## Quickstart (local)
1. Instala `terraform`, `kind`, `kubectl`, `helm`.
2. Desde `infra/terraform` ejecuta:
   ```bash
   terraform init
   terraform apply -auto-approve
