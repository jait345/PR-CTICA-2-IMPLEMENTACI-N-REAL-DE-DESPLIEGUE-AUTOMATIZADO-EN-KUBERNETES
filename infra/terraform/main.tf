terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
  required_version = ">= 1.0"
}

provider "null" {}

resource "null_resource" "kind_cluster" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create_kind.sh"
    interpreter = ["/bin/bash", "-c"]
  }
}

output "note" {
  value = "Run `kubectl get nodes` once provision finished. Kubeconfig is the default (~/.kube/config)."
}
