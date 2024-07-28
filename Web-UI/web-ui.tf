module "ebs_csi_driver" {
  source       = "github.com/raxkumar/terraform_modules/aws/eks_web_ui"

# use below variables if you want to deploy the web ui of other kubernetes versions, default is set for kubernetes version v1.25

#   dashboard-version = "v2.7.0"
#   dms-version = "v1.0.8"
}
