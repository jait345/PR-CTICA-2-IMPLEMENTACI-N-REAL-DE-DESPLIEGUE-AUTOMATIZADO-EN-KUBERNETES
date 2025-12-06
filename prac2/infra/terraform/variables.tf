variable "kubeconfig_path" {
  type = string
  default = "~/.kube/config"
}

variable "release_namespace" {
  type = string
  default = "release"
}

variable "prod_namespace" {
  type = string
  default = "prod"
}
