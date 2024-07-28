# output "cluster_endpoint" {
#   value = "data.aws_eks_cluster.cluster.endpoint"
# }

# resource "null_resource" "check-infra" {
#   provisioner "local-exec" {
    
#     command = <<-EOT
#         # -k tells curl to ignore any SSL certificate errors that may occur.
#         # -s makes curl operate in silent mode, so it doesn't show any progress or error messages.
#         # -o /dev/null redirects the response body to the null device, so it doesn't get printed to the console.
#         # -w "% {http_code}" tells curl to output only the HTTP status code of the response.

#         cluster_endpoint="https://ED01C34B4421934E633FE3DC9A41B20F.gr7.ap-south-1.eks.amazonaws.com"

#         http_status=$(curl -k -s -o /dev/null -w "%%{http_code}" $cluster_endpoint)

#         if [ $http_status -eq 200 ]; then
#             echo -e "\033[32;1m \U0001F389\U0001F389\U0001F389 Cluster is up and running... \U0001F389\U0001F389\U0001F389\033[0m"
#         else
#             echo -e "\033[31;1mThere is some error with the cluster\U0001F63F\033[0m"
#         fi
#     EOT

#     interpreter = ["bash", "-c"]
#   }
#   # depends_on = [
#   #   output.cluster_endpoint
#   # ]
# }
