data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = "${var.cluster_name}"
  depends_on = [
        aws_eks_cluster.demo-eks,
        aws_eks_node_group.worker-node-group
    ]
}
