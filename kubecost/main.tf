# Install or upgrade the kubecost chart
resource "helm_release" "kubecost" {
    name       = "kubecost"
    repository = "https://kubecost.github.io/cost-analyzer"
    chart      = "cost-analyzer"
    version    = "1.103.2"
    namespace  = "kubecost"
    create_namespace = true

    set {
        name  = "kubecostToken"
        value = "aGVsbUBrdWJlY29zdC5jb20=xm343yadf98"
    }

    # Set values from the values-eks-cost-monitoring.yaml file
    values = [
    file("kubecost.yml")
    ]
}