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

variable "hosted_zone" {
  description = "AWS hosted_zone to apply to resources"
  type        = string
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

variable "flux_wait" {
  description = "Wait for all manifests to apply"
  type        = bool
  default     = true
}

variable "manifests_path" {
  description = "Manifests dir inside GitRepository"
  type        = string
  default     = ""
}

