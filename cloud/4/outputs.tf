output "k8s_cluster_id" {
  value       = yandex_kubernetes_cluster.k8s_cluster.id
  description = "ID of Managed Kubernetes cluster"
}

output "k8s_cluster_name" {
  value       = yandex_kubernetes_cluster.k8s_cluster.name
  description = "Name of Managed Kubernetes cluster"
}

output "k8s_external_v4_endpoint" {
  value       = yandex_kubernetes_cluster.k8s_cluster.master[0].external_v4_endpoint
  description = "External API endpoint of Kubernetes master"
}

output "mysql_cluster_id" {
  value       = yandex_mdb_mysql_cluster.mysql.id
  description = "ID of MySQL cluster"
}

output "mysql_cluster_hosts" {
  value       = [for host in yandex_mdb_mysql_cluster.mysql.host : host.fqdn]
  description = "List of MySQL cluster host FQDNs"
}

output "mysql_database_name" {
  value       = var.db_name
  description = "Name of MySQL database"
}

output "mysql_user" {
  value       = var.db_user
  description = "MySQL database user"
}

output "kms_key_id" {
  value       = yandex_kms_symmetric_key.k8s_kms_key.id
  description = "ID of KMS symmetric key for Kubernetes secrets encryption"
}
