variable "worker_size" {
  default = "s-2vcpu-4gb-intel"
}

variable "worker_count" {
  default = 1
}

variable "do_token" {
  type = string
  description = "Digital ocean personal access token. Use -var 'do_token=<Your token>' to set this variable"
}