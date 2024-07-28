resource "kubernetes_namespace" "wdi" {
  metadata {
    name = "wdi" # Provide namespace here, default is "wdi"
  }
}

