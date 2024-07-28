module "ebs_csi_driver" {
  source       = "github.com/craxkumar/terraform_modules/aws/ebs_csi_driver"
  cluster-name = "demo-cluster"
  region       = "ap-south-1"
}
