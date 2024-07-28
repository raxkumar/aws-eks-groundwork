resource "aws_eks_cluster" "demo-eks" {
 name = "demo-cluster"
 version = "1.25"
 role_arn = aws_iam_role.eks-iam-role.arn

 vpc_config {
  subnet_ids = [var.subnet_id_1, var.subnet_id_2]
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}

output "issuer-url" {
  value = aws_eks_cluster.demo-eks.identity
}

