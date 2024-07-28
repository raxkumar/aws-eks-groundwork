# locals {
#   istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
# }

# resource "helm_release" "istio-base" {
#   repository       = local.istio_charts_url
#   chart            = "base"
#   name             = "istio-base"
#   timeout          = 120
#   namespace        = "istio-system"
#   version          = "1.17.1" //"1.16.2"
#   create_namespace = true
#   cleanup_on_fail  = true
#   force_update     = false

#   depends_on = [
#     aws_eks_cluster.demo-eks,
#     aws_eks_node_group.worker-node-group
#   ]
# }

# resource "helm_release" "istiod" {
#   repository       = local.istio_charts_url
#   chart            = "istiod"
#   name             = "istiod"
#   timeout          = 120
#   namespace        = "istio-system"
#   create_namespace = true
#   version          = "1.17.1" //"1.16.2"
#   cleanup_on_fail  = true
#   force_update     = false
#   depends_on       = [
#     helm_release.istio-base,
#     aws_eks_cluster.demo-eks,
#     aws_eks_node_group.worker-node-group
#     ]
# }

# resource "helm_release" "istio-ingressgateway" {
#   repository      = local.istio_charts_url
#   chart           = "gateway"
#   name            = "istio-ingressgateway"
#   cleanup_on_fail = true
#   force_update    = false
#   timeout         = 500
#   namespace       = "istio-system"
#   version         = "1.17.1"//"1.16.2"
#   depends_on      = [
#     helm_release.istiod,
#     aws_eks_cluster.demo-eks,
#     aws_eks_node_group.worker-node-group
#   ]

#   set {
#     name = "name"
#     value = "istio-ingressgateway"
#   }
#   set {
#     name = "labels.app"
#     value = "istio-ingressgateway"
#   }
#   set {
#     name = "labels.istio"
#     value = "ingressgateway"
#   }
# }


