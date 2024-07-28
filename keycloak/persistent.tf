resource "kubernetes_storage_class" "example" {
  metadata {
    name = "kc-sc"
  }
  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "Immediate"
  reclaim_policy      = "Delete"
  parameters = {
    "type" = "gp2"
  }
  
}

resource "kubernetes_persistent_volume_claim" "example" {
  # wait_until_bound = true
  metadata {
    name = "exampleclaimname"
    namespace = kubernetes_namespace.wdi.metadata.0.name
    # annotations = {
    #   storage-provisioner = "ebs.csi.aws.com" 
    # }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "19Gi"
      }
    }
    # volume_name = "examplevolumename"
    storage_class_name = "kc-sc"
  }
}

# resource "kubernetes_persistent_volume" "example" {
#   metadata {
#     name = "examplevolumename"
#   }
#   spec {
#     capacity = {
#       storage = "20Gi"
#     }
#     access_modes = ["ReadWriteOnce"]
    
#     // This will change in future, as of this will work for minikube.
#     persistent_volume_source {
#     #   host_path {
#     #     path = "/data/db"
#     #   }
#         # aws_elastic_block_store {
#         #     volume_id = "vol-00b2e2b71e5b2e6ed"
#         #     fs_type = "ext4"
#         # }
#         # local {
#         #     path = "/data/db"
#         # }
#         csi {
#           driver = "ebs.csi.aws.com"
#           volume_handle = "vol-00b2e2b71e5b2e6ed"
#         }
#     }
#     storage_class_name = "kc-sc"
#   }
# }