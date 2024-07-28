resource "kubernetes_service" "postgres_service" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.wdi.metadata.0.name
    labels = {
      app = "postgres"
    }
  }

  spec {
    selector = {
      app  = kubernetes_stateful_set.postgres_deployment.metadata.0.labels.app 
    }

    port {
      port = 5432
    }

    cluster_ip = "None"
  }
}

# resource "kubernetes_persistent_volume_claim" "demo_app_pvc" {
#   metadata {
#     name      = "mysql-pvc"
#     namespace = kubernetes_namespace.demo_app_ns.metadata.0.name
#     labels = {
#       app = "demo-app"
#     }
#   }

#   spec {
#     access_modes = ["ReadWriteOnce"]

#     resources {
#       requests = {
#         storage = "1Gi"
#       }
#     }
#   }
# }

resource "kubernetes_stateful_set" "postgres_deployment" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.wdi.metadata.0.name
    labels = {
      app = "postgres"
    }
  }

  spec {
    selector {
      match_labels = {
        app  = "postgres"
      }
    }

    service_name = "postgres" 



    template {
      metadata {
        labels = {
          app  = "postgres"
        }
      }

      spec {
        container {
          image = "postgres:latest"
          name  = "postgres"

          env {
            name = "POSTGRES_DB"
            value_from {
              config_map_key_ref {
                key  = "keycloak-db-name"
                name = kubernetes_config_map.keycloak_config_map.metadata.0.name
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                key  = "keycloak-db-password"
                name = kubernetes_secret.keycloak_secret.metadata.0.name
              }
            }
          }

          env {
            name = "PGDATA"
            value = "/var/lib/postgresql/data/xyz"
          }

          liveness_probe {
            tcp_socket {
              port = 5432
            }
          }

          port {
            name           = "postgres"
            container_port = 5432
          }

          volume_mount {
            name       = "something"
            mount_path = "/var/lib/postgresql/data"
          }

        }

        volume {
          name = "something"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.example.metadata.0.name
          }
        }

      }
    }
  }
}

