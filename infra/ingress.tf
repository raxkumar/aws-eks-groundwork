# resource "helm_release" "nginx-ingress-controller" {
#   depends_on = [
#     aws_eks_cluster.demo-eks,
#     aws_eks_node_group.worker-node-group
#   ]
#   name       = "nginx-ingress-controller"
#   repository = "https://kubernetes.github.io/ingress-nginx/"
#   chart      = "ingress-nginx"
#   version    = "4.2.2"
# }

