terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = ">= 2.4.0"
    }
    azurem = {
      source = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurem" {
  features {}

  subscription_id = "${env.ARM_SUBSCRIPTION_ID}"
  tenant_id = "${env.ARM_TENANT_ID}"
  client_id = "${env.ARM_CLIENT_ID}"
  client_secret = "${env.ARM_CLIENT_SECRET}"
}

provider "digitalocean" {
  token = var.do_token
}


data "digitalocean_kubernetes_versions" "current" {
  version_prefix = var.cluster_version
}

resource "digitalocean_kubernetes_cluster" "k8s-cluster" {
    name = var.cluster_name
    region = var.cluster_region
    # version = "1.23.9-do.0"
    version = data.digitalocean_kubernetes_versions.current.version_prefix

    node_pool {
      name = "master"
      size = var.worker_size
      node_count = 1
    }
}

resource "digitalocean_kubernetes_node_pool" "worker-pool" {
  cluster_id = digitalocean_kubernetes_cluster.k8s-cluster.id

  name = "worker-pool"
  size = var.worker_size
  node_count = var.worker_count
  labels = {
    service = "facuxfdz-worker"
  }
}