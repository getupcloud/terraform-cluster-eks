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

variable "manifests_path" {
  description = "Manifests dir inside GitRepository"
  type        = string
  default     = ""
}

variable "workers_group_defaults" {
  description = "Workers group defaults from parent"
  type        = any
  default     = {}
}

variable "default_iam_role_arn" {
  description = "ARN of the default IAM worker role to use if one is not specified in `var.node_groups` or `var.node_groups_defaults`"
  type        = string
  default     = ""
}