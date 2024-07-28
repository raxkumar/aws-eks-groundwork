variable "cluster-name" {
  type    = string
  default = "demo-cluster"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "account-id" {
  type    = string
  default = "<aws_account_id"
}

# variable "cluster-identity-oidc-issuer" {
#   type    = string
#   // starts with oidc.xxx.xxx.xxx.xxx.xxx.xxx.xxx.xxx
#   default = "oidc.eks.ap-south-1.amazonaws.com/id/A3D53EFF9CDDBFDBC47A40DAE44C8C20"
# }

# variable "cluster-identity-oidc-issuer-url" {
#   type    = string
#   // starts with oidc.xxx.xxx.xxx.xxx.xxx.xxx.xxx.xxx
#   default = "https://oidc.eks.ap-south-1.amazonaws.com/id/A3D53EFF9CDDBFDBC47A40DAE44C8C20"
# }

variable "oidc-issuer-id" {
  type    = string
  default = "36783AC7774A54531228F829C6C68F9A"  // This value will be automatically replaced with <oidc-issuer-id.txt> once the script runs
}
