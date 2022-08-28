terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = ">= 2.4.0"
    }
  }
}

provider "digitalocean" {
  # Provider is configured using the following env var
  # env: DIGITALOCEAN_ACCESS_TOKEN
  token = var.do_token
}


data "digitalocean_kubernetes_versions" "current" {
  version_prefix = var.cluster_version
}

resource "digitalocean_kubernetes_cluster" "k8s-cluster" {
    name = var.cluster_name
    region = var.cluster_region
    version = data.digitalocean_kubernetes_versions.current.latest_version

    node_pool {
      name = "worker-pool"
      size = var.worker_size
      node_count = var.worker_count
    }
}

