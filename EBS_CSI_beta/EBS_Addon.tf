resource "aws_eks_addon" "eks_addon" {
  cluster_name = "${var.cluster-name}"
  addon_name   = "aws-ebs-csi-driver"
  service_account_role_arn = "arn:aws:iam::${var.account-id}:role/AmazonEKS_EBS_CSI_DriverRole"

  depends_on = [
    aws_iam_role.ebs_csi_role
  ]
}