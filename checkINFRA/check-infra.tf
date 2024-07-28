resource "null_resource" "check-infra" {
  provisioner "local-exec" {
    
    command = <<-EOT
        # -k tells curl to ignore any SSL certificate errors that may occur.
        # -s makes curl operate in silent mode, so it doesn't show any progress or error messages.
        # -o /dev/null redirects the response body to the null device, so it doesn't get printed to the console.
        # -w "% {http_code}" tells curl to output only the HTTP status code of the response.

        cluster_endpoint="${data.aws_eks_cluster.cluster.endpoint}/version"

        http_status=$(curl -k -s -o /dev/null -w "%%{http_code}" $cluster_endpoint)

        if [ $http_status -eq 200 ]; then
            echo ""
            echo -e "\033[32;1m \U0001F389\U0001F389\U0001F389 Cluster is up and running... \U0001F389\U0001F389\U0001F389\033[0m"
            echo ""
        else
            echo -e "\033[31;1mThere is some error with the cluster\U0001F63F\033[0m"
        fi
    EOT

    interpreter = ["bash", "-c"]
  }
  depends_on = [
    data.aws_eks_cluster.cluster
  ]
}
