resource "kubernetes_namespace" "app" {
  metadata {
    name = "production"
  }
}
