output "cluster_identity_oidc_issuer" {
  value = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "cluster_identity_oidc_issuer_arn" {
  value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
}

module "eks-cluster-autoscaler" {
  source  = "github.com/coMakeIT-TIC/terraform_modules/aws/eks_autoscaler"
  # version = "2.1.0"

  # insert the 3 required variables here
  cluster_name = var.cluster_name
  cluster_identity_oidc_issuer = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  cluster_identity_oidc_issuer_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
  
#   values = yamlencode({
#     "image" : {
#       "tag" : "v1.26.2"
#     }
#   })

  depends_on = [
    aws_eks_cluster.demo-eks,
    aws_eks_node_group.worker-node-group,
    aws_iam_openid_connect_provider.cluster_oidc
  ]
}
