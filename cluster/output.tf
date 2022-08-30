output "cluster_name" {
    value = digitalocean_kubernetes_cluster.k8s-cluster.name
}

output "cluster_id" {
  value = digitalocean_kubernetes_cluster.k8s-cluster.id  
}

output "worker_node_pool_id" {
  value = digitalocean_kubernetes_node_pool.worker-pool.id
}