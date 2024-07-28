data "tls_certificate" "cluster" {
    url =  "https://oidc.eks.${var.region}.amazonaws.com/id/${split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer)[length(split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer))-1]}" 
    depends_on = [
        aws_eks_cluster.demo-eks,
        aws_eks_node_group.worker-node-group
    ]
}

resource "aws_iam_openid_connect_provider" "cluster_oidc" {
    url =  "https://oidc.eks.${var.region}.amazonaws.com/id/${split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer)[length(split("/", data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer))-1]}"
    client_id_list = [
        "sts.amazonaws.com"
    ]
    thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
    depends_on = [
        data.tls_certificate.cluster,
        aws_eks_cluster.demo-eks,
        aws_eks_node_group.worker-node-group
    ]
}