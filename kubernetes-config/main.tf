terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = ">= 2.4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = " >= 2.0.1"
    }
  }
}

data "digitalocean_kubernetes_cluster" "k8s-cluster" {
    name = var.cluster_name
    depends_on = [
      var.cluster_id
    ]
}

resource "local_file" "kubeconfig" {
    content = data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].raw_config
    filename = "kubeconfig.yaml"
}
