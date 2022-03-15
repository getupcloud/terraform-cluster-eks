provider "kubernetes" {
  config_path            = var.use_kubeconfig ? var.kubeconfig_filename : null
  host                   = var.use_kubeconfig ? null : local.api_endpoint
  cluster_ca_certificate = var.use_kubeconfig ? null : local.certificate_authority_data
  token                  = var.use_kubeconfig ? null : local.token
}

provider "kubectl" {
  load_config_file       = var.use_kubeconfig ? null : false
  host                   = var.use_kubeconfig ? null : local.api_endpoint
  cluster_ca_certificate = var.use_kubeconfig ? null : local.certificate_authority_data
  token                  = var.use_kubeconfig ? null : local.token
  apply_retry_count      = 2
}
