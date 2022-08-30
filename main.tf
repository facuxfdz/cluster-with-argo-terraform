terraform {
  required_version = ">= 0.12"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    azurem = {
      source = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "tfstate"
    storage_account_name = "tfstate27802"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

module "my-cluster" {
  source = "./cluster"
  cluster_name = "facuxfdz-cluster"
  cluster_region = "nyc1"
  cluster_version = "1.23.9-do.0"

  worker_size = var.worker_size
  worker_count = var.worker_count

  do_token = var.do_token
}

module "kubernetes-config" {
  source = "./kubernetes-config"
  cluster_name = module.my-cluster.cluster_name
  cluster_id = module.my-cluster.cluster_id
  worker_node_pool_id = module.my-cluster.worker_node_pool_id
  do_token = var.do_token
}