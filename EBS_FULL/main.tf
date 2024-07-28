data "aws_eks_cluster" "cluster" {
  name = "${var.cluster-name}"
}

# data "tls_certificate" "cluster" {
#   url =  "https://oidc.eks.${var.region}.amazonaws.com/id/${split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer)[length(split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer))-1]}" 
# }

# resource "aws_iam_openid_connect_provider" "cluster_oidc" {
#     url =  "https://oidc.eks.${var.region}.amazonaws.com/id/${split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer)[length(split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer))-1]}"
#     client_id_list = [
#         "sts.amazonaws.com"
#     ]
#     thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
#     depends_on = [
#         data.tls_certificate.cluster
#     ]
# }

# The above three blocks should be shifted to the infra directory
# as it is used to create oidc provider (The OIDC (OpenID Connect) 
# identity provider is required for an EKS (Amazon Elastic Kubernetes Service)
# cluster to enable authentication between Kubernetes and AWS services.)

# Print's the oidc_issuer_id

# output "oidc_issuer_id" {
#   value = split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer)[length(split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer))-1]
# }

resource "aws_iam_role" "ebs_csi_role" {

    name = "${var.cluster-name}_AmazonEKS_EBS_CSI_DriverRole"

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${var.account-id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer)[length(split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer))-1]}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                "oidc.eks.${var.region}.amazonaws.com/id/${split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer)[length(split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer))-1]}:aud": "sts.amazonaws.com",
                "oidc.eks.${var.region}.amazonaws.com/id/${split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer)[length(split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer))-1]}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
                }
            }
            }
        ]
    })

    managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]

    depends_on = [
      aws_iam_openid_connect_provider.cluster_oidc
    ]
}

resource "aws_eks_addon" "eks_addon" {
  cluster_name = "${var.cluster-name}"
  addon_name   = "aws-ebs-csi-driver"
  service_account_role_arn = "arn:aws:iam::${var.account-id}:role/${var.cluster-name}_AmazonEKS_EBS_CSI_DriverRole"

  depends_on = [
    aws_iam_role.ebs_csi_role
  ]
}



