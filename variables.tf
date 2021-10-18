## Common variables

variable "name" {
  description = "Cluster name"
  type        = string
}

variable "tags" {
  description = "AWS tags to apply to resources"
  type        = any
  default     = {}
}
variable "customer_name" {
  description = "customer name"
  type        = string
}
variable "kubeconfig_filename" {
  description = "Kubeconfig path"
  default     = "~/.kube/config"
  type        = string
}

variable "get_kubeconfig_command" {
  description = "Command to create/update kubeconfig"
  default     = "kind export kubeconfig --name $CLUSTER_NAME"
}

variable "flux_git_repo" {
  description = "GitRepository URL."
  type        = string
  default     = ""
}

variable "manifests_path" {
  description = "Manifests dir inside GitRepository"
  type        = string
  default     = ""
}
