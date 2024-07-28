terraform {
 required_providers {
  aws = {
   source = "hashicorp/aws"
  }
 }
}

# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}