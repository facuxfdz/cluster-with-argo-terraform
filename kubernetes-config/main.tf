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

provider "kubernetes" {
  host = data.digitalocean_kubernetes_cluster.k8s-cluster.endpoint
  token = data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(data.digitalocean_kubernetes_cluster.k8s-cluster.kube_config[0].cluster_ca_certificate)
}


resource "kubernetes_namespace" "argocd-namespace" {
  metadata {
    name = "argocd"
  }
}

resource "null_resource" "name" {
  depends_on = [
    kubernetes_namespace.argocd-namespace
  ]
  provisioner "local-exec" {
    command = "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --kubeconfig=kubeconfig.yaml && sleep 120 && kubectl apply -f https://raw.githubusercontent.com/facuxfdz/response-time-app-infra/master/application.yaml --kubeconfig=kubeconfig.yaml"
  }
}