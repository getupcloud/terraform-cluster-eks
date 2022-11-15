module "internet" {
  source = "github.com/getupcloud/terraform-module-internet?ref=v1.0"
}

module "cluster" {
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/
  source = "terraform-aws-modules/eks/aws"

  ## MUST use version <18 for now: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1702#issuecomment-1003445454
  version = "17.23.0"

  create_eks      = true
  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  vpc_id          = var.vpc_id
  map_users       = local.map_users
  map_roles       = local.map_roles
  subnets         = local.subnets
  enable_irsa     = true

  node_groups          = local.node_groups
  node_groups_defaults = local.node_groups_defaults

  cluster_endpoint_public_access       = var.endpoint_public_access
  cluster_endpoint_public_access_cidrs = local.cluster_endpoint_public_access_cidrs

  cluster_endpoint_private_access       = var.endpoint_private_access
  cluster_endpoint_private_access_cidrs = var.endpoint_private_access_cidrs

  tags = merge({
    Name = var.cluster_name
    Role = "eks-cluster"
  }, var.tags)

  cluster_tags = var.cluster_tags

  depends_on = [
    shell_script.pre_create
  ]
}

module "flux" {
  source = "github.com/getupcloud/terraform-module-flux?ref=v2.0.0-alpha5"

  git_repo                = var.flux_git_repo
  manifests_path          = "./clusters/${var.cluster_name}/eks/manifests"
  wait                    = var.flux_wait
  flux_version            = var.flux_version
  manifests_template_vars = local.manifests_template_vars
  debug                   = var.dump_debug
}

module "cronitor" {
  source = "github.com/getupcloud/terraform-module-cronitor?ref=v2.0"

  api_endpoint       = module.cluster.cluster_endpoint
  cronitor_enabled   = var.cronitor_enabled
  cluster_name       = module.cluster.cluster_id
  cluster_sla        = var.cluster_sla
  customer_name      = var.customer_name
  suffix             = "eks"
  tags               = [var.region]
  pagerduty_key      = var.cronitor_pagerduty_key
  notification_lists = var.cronitor_notification_lists
}

module "opsgenie" {
  source = "github.com/getupcloud/terraform-module-opsgenie?ref=v1.2"

  opsgenie_enabled = var.opsgenie_enabled
  customer_name    = var.customer_name
  cluster_name     = var.cluster_name
  owner_team_name  = var.opsgenie_team_name
}

module "teleport-agent" {
  source = "github.com/getupcloud/terraform-module-teleport-agent-config?ref=v0.3"

  auth_token       = var.teleport_auth_token
  cluster_name     = var.cluster_name
  customer_name    = var.customer_name
  cluster_sla      = var.cluster_sla
  cluster_provider = "eks"
  cluster_region   = var.region
}
