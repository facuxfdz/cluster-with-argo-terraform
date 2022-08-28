output "cluster_name" {
    value = digitalocean_kubernetes_cluster.k8s-cluster.name
}

output "cluster_id" {
  value = digitalocean_kubernetes_cluster.k8s-cluster.id  
}