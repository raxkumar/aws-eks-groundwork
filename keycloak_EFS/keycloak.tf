resource "kubernetes_service" "keycloak_service" {
  metadata {
    name      = "keycloak-service"
    namespace = kubernetes_namespace.wdi.metadata.0.name
    labels = {
      app  = "keycloak"
    }
  }

  spec {
    type = "ClusterIP"
    # type = "NodePort"
    selector = {
      app  = "keycloak"
    }

    port {
      name        = "http"
      protocol    = "TCP"
      port        = 8080
      target_port = 8080
      # node_port   = 30001
    }
  }

  depends_on = [
    kubernetes_stateful_set.postgres_deployment,
    kubernetes_service.postgres_service
 ]

}


resource "kubernetes_deployment" "keyloak_deployment" {
  metadata {
    name      = "keyloak-deployment"
    namespace = kubernetes_namespace.wdi.metadata.0.name
    labels = {
      app  = "keycloak"
    }
  }

  spec {
    selector {
      match_labels = {
        app  = "keycloak"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          app  = "keycloak"
        }
      }

      spec {
        container {
          image = "quay.io/keycloak/keycloak:20.0.2" # Provide keycloak image url
          name  = "keycloak"

          env {
            name = "KEYCLOAK_ADMIN"
            value_from {
              config_map_key_ref {
                key  = "keycloak-admin-username"
                name = kubernetes_config_map.keycloak_config_map.metadata.0.name
              }
            }
          }

          env {
            name = "KEYCLOAK_ADMIN_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "keycloak-admin-password"
                name = kubernetes_secret.keycloak_secret.metadata.0.name
              }
            }
          }

          # env {
          #   name = "KC_HOSTNAME_URL"
          #   value = "https://kc.cdkdemo.tk/"
          # }

          # env {
          #   name = "KC_HOSTNAME_STRICT_HTTPS"
          #   value = "false"
          # }
          # env {
          #   name = "KC_HOSTNAME_STRICT"
          #   value = "false"
          # }
          # env {
          #   name = "KC_PROXY"
          #   value = "edge"
          # }
          # env {
          #   name = "KC_TRANSACTION_XA_ENABLED"
          #   value = "false"
          # }
          # env {
          #   name = "KC_HTTP_ENABLED"
          #   value = "true"
          # }
          # env {
          #   name = "KC_HOSTNAME_ADMIN_URL"
          #   value = "http://kc.cdkdemo.tk/admin/master/console/"
          # }
          # env {
          #   name = "PROXY_ADDRESS_FORWARDING"
          #   value = "true"
          # }
          # env {
          #   name = "KC_PROXY"
          #   value = "edge"
          # }

          // connect with external storage (postgres)

          env {
            name = "KC_DB_VENDOR"
            value_from {
              config_map_key_ref {
                key  = "keycloak-db-vendor"
                name = kubernetes_config_map.keycloak_config_map.metadata.0.name
              }
            }
          }

          env {
            name = "KC_DB"
            value_from {
              config_map_key_ref {
                key  = "keycloak-db"
                name = kubernetes_config_map.keycloak_config_map.metadata.0.name
              }
            }
          }

          env {
            name = "KC_DB_ADDR"
            value_from {
              config_map_key_ref {
                key  = "keycloak-db-addr"
                name = kubernetes_config_map.keycloak_config_map.metadata.0.name
              }
            }
          }

          env {
            name = "KC_DB_DATABASE"
            value_from {
              config_map_key_ref {
                key  = "keycloak-db-name"
                name = kubernetes_config_map.keycloak_config_map.metadata.0.name
              }
            }
          }
          

          env {
            name = "KC_DB_USERNAME"
            value_from {
              config_map_key_ref {
                key  = "keycloak-db-username"
                name = kubernetes_config_map.keycloak_config_map.metadata.0.name
              }
            }
          }

          env {
            name = "KC_DB_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "keycloak-db-password"
                name = kubernetes_secret.keycloak_secret.metadata.0.name
              }
            }
          }

          env{
            name = "KC_DB_URL"
            value_from {
              config_map_key_ref {
                key  = "keycloak-db-url"
                name = kubernetes_config_map.keycloak_config_map.metadata.0.name
              }
            }
          }


          command = ["/opt/keycloak/bin/kc.sh"]
          args = [ "start-dev" ]
          
          port {
            name           = "keycloak"
            container_port = 8080
          }
        }
      }
    }
  }

   depends_on = [
    kubernetes_stateful_set.postgres_deployment,
    kubernetes_service.postgres_service
 ]

}
