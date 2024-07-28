data "tls_certificate" "cluster" {
  url =  "https://oidc.eks.${var.region}.amazonaws.com/id/${var.oidc-issuer-id}"         //"${var.cluster-identity-oidc-issuer-url}" 
}

resource "aws_iam_openid_connect_provider" "cluster_oidc" {
    url = "https://oidc.eks.${var.region}.amazonaws.com/id/${var.oidc-issuer-id}"
    client_id_list = [
        "sts.amazonaws.com"
    ]
    thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]

    depends_on = [
        data.tls_certificate.cluster
    ]
}