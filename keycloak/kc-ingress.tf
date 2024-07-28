resource "kubernetes_ingress_v1" "example" {
  # wait_for_load_balancer = true
  metadata {
    name = "ingress-nginx"
    namespace = "wdi"
    annotations = {
      "nginx.ingress.kubernetes.io/affinity" = "cookie"
      "nginx.ingress.kubernetes.io/session-cookie-name" = "route"
      "nginx.ingress.kubernetes.io/session-cookie-expires" = "172800"
      "nginx.ingress.kubernetes.io/session-cookie-max-age" = "172800"
    }
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
