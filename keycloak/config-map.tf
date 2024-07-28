resource "kubernetes_config_map" "keycloak_config_map" {
  metadata {
    name = "keycloak-config-map"
    namespace = kubernetes_namespace.wdi.metadata.0.name
  }

  data = {
    keycloak-admin-username = "admin"                                # provide admin username for keycloak(admin-cli)
    keycloak-db-name        = "keycloak"                             # provide database name for keycloak
    keycloak-db-vendor      = "POSTGRES"                             # provide database vendor for keycloak
    keycloak-db             = "postgres"                             # provide database for keycloak
    keycloak-db-addr        = "postgres"                             # provide database address for keycloak
    keycloak-db-username    = "postgres"                             # provide database username for keycloak
    keycloak-db-url         = "jdbc:postgresql://postgres/keycloak"  # provide database URL for keycloak
  }
}
