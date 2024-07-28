resource "kubernetes_secret" "keycloak_secret" {
  metadata {
    name = "keycloak-pass"
    namespace = kubernetes_namespace.wdi.metadata.0.name
  }
  data = {
    keycloak-admin-password = "admin"    # Provide admin password for keycloak(admin-cli)
    keycloak-db-password    = "keycloak" # provide db password for keycloak
  }
}