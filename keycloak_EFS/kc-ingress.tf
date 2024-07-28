resource "kubernetes_ingress_v1" "example" {
  # wait_for_load_balancer = true
  metadata {
    name = "ingress-nginx"
    namespace = "wdi"
    # annotations = {
    #   "nginx.ingress.kubernetes.io/backend-protocol" =  "HTTPS"
    # }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "kc.cdkdemo.tk"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "keycloak-service"
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}
