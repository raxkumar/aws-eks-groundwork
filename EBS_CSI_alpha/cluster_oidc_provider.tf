resource "null_resource" "get_oidc_issuer_id" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks describe-cluster  --name ${var.cluster-name}  --query "cluster.identity.oidc.issuer" |cut  --complement -d '"' -f3 | cut -d "/" -f5 > oidc-issuer-id.txt
    EOT
  }
}

resource "null_resource" "replace_oidc_issuer_id" {
  provisioner "local-exec" {
    command = <<EOT
      sed -i "s/oidc-issuer-id.txt/$(cat oidc-issuer-id.txt)/" ../EBS_CSI_beta/variable.tf 
    EOT
  }
  depends_on = [
    null_resource.get_oidc_issuer_id
  ]
}
