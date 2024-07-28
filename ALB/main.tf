# data "http" "aws-lb-controller-policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json"

#   request_headers = {
#     Accept = "application/json"
#   }
# }

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "wdi-eks" {
  name = var.cluster_name
}

locals {
  wdi-eks-oidc-id = "${split("/", data.aws_eks_cluster.wdi-eks.identity[0].oidc[0].issuer)[length(split("/", data.aws_eks_cluster.wdi-eks.identity[0].oidc[0].issuer))-1]}"
  eks-charts = "https://aws.github.io/eks-charts"
}

resource "aws_iam_policy" "load-balancer-controller" {
  name        = "${var.cluster_name}_AWSLoadBalancerControllerIAMPolicy"
  policy      = tostring(file("${path.module}/iam_policy.json"))
  description = "Load Balancer Controller add-on for EKS"
}

resource "aws_iam_role" "eks-lb-controller-role" {
  name = "${var.cluster_name}_AmazonEKSLoadBalancerControllerRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${local.wdi-eks-oidc-id}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "oidc.eks.${var.region}.amazonaws.com/id/${local.wdi-eks-oidc-id}:aud" : "sts.amazonaws.com",
            "oidc.eks.${var.region}.amazonaws.com/id/${local.wdi-eks-oidc-id}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks-lb-role-attach" {
  role       = aws_iam_role.eks-lb-controller-role.name
  policy_arn = aws_iam_policy.load-balancer-controller.arn
}

resource "kubernetes_service_account" "aws-load-balancer-controller" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/component" = "controller"
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.eks-lb-controller-role.name}"
    }
  }
}

resource "helm_release" "aws-load-balancer-controller" {
  repository       = local.eks-charts
  name             = "aws-load-balancer-controller"
  chart            = "aws-load-balancer-controller"
  namespace        = "kube-system"
  cleanup_on_fail  = true
  force_update     = false

  set {
    name = "clusterName"
    value = "${var.cluster_name}"
  }

  set {
    name = "serviceAccount.create"
    value = false
  }

  set {
    name = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}
