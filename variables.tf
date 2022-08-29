variable "worker_size" {
  default = "s-1vcpu-2gb"
}

variable "worker_count" {
  default = 2
}

variable "do_token" {
  type = string
  description = "Digital ocean personal access token. Use -var 'do_token=<Your token>' to set this variable"
}