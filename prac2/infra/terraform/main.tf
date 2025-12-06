terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">=2.23.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">=2.13.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

resource "null_resource" "kind_cluster" {
  provisioner "local-exec" {
    command = "kind create cluster --name practicascicd || true"
  }
}

resource "kubernetes_namespace" "ns_release" {
  depends_on = [null_resource.kind_cluster]
  metadata {
    name = var.release_namespace
  }
}

resource "kubernetes_namespace" "ns_prod" {
  depends_on = [null_resource.kind_cluster]
  metadata {
    name = var.prod_namespace
  }
}

resource "helm_release" "ingress_nginx" {
  depends_on = [null_resource.kind_cluster]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  create_namespace = true
}
