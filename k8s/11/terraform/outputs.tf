output "cluster_id" {
  value = yandex_kubernetes_cluster.k8s_cluster.id
}

output "cluster_name" {
  value = yandex_kubernetes_cluster.k8s_cluster.name
}

output "cluster_external_v4_endpoint" {
  value = yandex_kubernetes_cluster.k8s_cluster.master[0].external_v4_endpoint
}

output "connect_command" {
  value = "yc managed-kubernetes cluster get-credentials ${yandex_kubernetes_cluster.k8s_cluster.name} --external"
}
