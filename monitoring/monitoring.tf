locals {
  grafana-yamls = [for data in split("---", file("./grafana.yaml")): yamldecode(data)]
}
resource "kubernetes_manifest" "grafana" {
  count = length(local.grafana-yamls)
  manifest = local.grafana-yamls[count.index]
}

locals {
  kiali-yamls = [for data in split("---", file("./kiali.yaml")): yamldecode(data)]
}
resource "kubernetes_manifest" "kiali" {
  count = length(local.kiali-yamls)
  manifest = local.kiali-yamls[count.index]
  depends_on = [
    kubernetes_manifest.grafana
  ]
}

locals {
  prometheus-yamls = [for data in split("---", file("./prometheus.yaml")): yamldecode(data)]
}
resource "kubernetes_manifest" "prometheus" {
  count = length(local.prometheus-yamls)
  manifest = local.prometheus-yamls[count.index]
  depends_on = [
    kubernetes_manifest.grafana,
    kubernetes_manifest.kiali
  ]
}
