locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

resource "helm_release" "istio-base" {
  repository       = local.istio_charts_url
  chart            = "base"
  name             = "istio-base"
  timeout          = 120
  namespace        = "istio-system"
  version          = "1.17.1" //"1.16.2"
  create_namespace = true
  cleanup_on_fail  = true
  force_update     = false
}

resource "helm_release" "istiod" {
  repository       = local.istio_charts_url
  chart            = "istiod"
  name             = "istiod"
  timeout          = 120
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.17.1" //"1.16.2"
  cleanup_on_fail  = true
  force_update     = false
  depends_on       = [
    helm_release.istio-base
    ]
}

resource "helm_release" "istio-ingressgateway" {
  repository      = local.istio_charts_url
  chart           = "gateway"
  name            = "istio-ingressgateway"
  cleanup_on_fail = true
  force_update    = false
  timeout         = 500
  namespace       = "istio-system"
  version         = "1.17.1"//"1.16.2"
  depends_on      = [
    helm_release.istiod
  ]

  set {
    name = "name"
    value = "istio-ingressgateway"
  }
  set {
    name = "labels.app"
    value = "istio-ingressgateway"
  }
  set {
    name = "labels.istio"
    value = "ingressgateway"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "ingress"
    namespace = "istio-system"
    labels = {
      app = "ingress"
    }
    annotations = {
      "kubernetes.io/ingress.class"       = "alb"
      "alb.ingress.kubernetes.io/scheme"  = "internet-facing"
      "alb.ingress.kubernetes.io/subnets" = "subnet-52f93c29, subnet-a89aabe5"
      "alb.ingress.kubernetes.io/load-balancer-name" = "${var.cluster_name}-istio-alb"
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service {
              name = "istio-ingressgateway"
              port {
                number = 80
              }
            }
          }
          path = "/*"
        }
      }
    }
  }

  depends_on = [
    helm_release.istio-ingressgateway
  ]
}

data "aws_lb" "istio_alb" {
  name = "${var.cluster_name}-istio-alb"
  depends_on = [
    kubernetes_ingress_v1.ingress
  ]
}


resource "null_resource" "print_alb_dns_name" {
  provisioner "local-exec" {
    command = "echo ${var.cluster_name} >> alb_dns_name.txt"
  }
  depends_on = [
    data.aws_lb.istio_alb
  ]
}
