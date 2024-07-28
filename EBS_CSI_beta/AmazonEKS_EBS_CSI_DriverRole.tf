resource "aws_iam_role" "ebs_csi_role" {

    name = "AmazonEKS_EBS_CSI_DriverRole"

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${var.account-id}:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/${var.oidc-issuer-id}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc-issuer-id}:aud": "sts.amazonaws.com",
                "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc-issuer-id}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
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

# resource "null_resource" "annotate_serviceaccount" {
#   provisioner "local-exec" {
#     command = "kubectl annotate serviceaccount ebs-csi-controller-sa -n kube-system eks.amazonaws.com/role-arn=arn:aws:iam::${var.account-id}:role/AmazonEKS_EBS_CSI_DriverRole"
#   }
#   depends_on = [
#     aws_iam_role.ebs_csi_role
#   ]
# }

# resource "null_resource" "restart_ebs-csi-controller" {
#   provisioner "local-exec" {
#     command = "kubectl rollout restart deployment ebs-csi-controller -n kube-system"
#   }
#   depends_on = [
#     null_resource.annotate_serviceaccount
#   ]
# }