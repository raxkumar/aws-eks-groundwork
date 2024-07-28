data "aws_caller_identity" "current" {}
data "aws_eks_cluster" "cluster" {
  name = "demo-cluster"
}

output "cluster_identity_oidc_issuer" {
  value = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

output "cluster_identity_oidc_issuer_arn" {
  value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
}

module "eks-cluster-autoscaler" {
  source  = "lablabs/eks-cluster-autoscaler/aws"
  version = "2.1.0"
  # insert the 3 required variables here


  cluster_name = var.cluster_name
  cluster_identity_oidc_issuer = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
  cluster_identity_oidc_issuer_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}"
}


