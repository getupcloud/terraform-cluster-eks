module "internet" {
  source = "github.com/getupcloud/terraform-module-internet?ref=v1.0"
}

module "cluster" {
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 17.22"

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

  depends_on = [
    shell_script.pre_create
  ]
}

module "flux" {
  source = "github.com/getupcloud/terraform-module-flux?ref=v1.10"

  git_repo       = var.flux_git_repo
  manifests_path = "./clusters/${var.cluster_name}/eks/manifests"
  wait           = var.flux_wait
  flux_version   = var.flux_version

  flux_template_vars = local.irsa_arn_template_vars

  manifests_template_vars = merge(
    local.irsa_arn_template_vars,
    {
      alertmanager_cronitor_id : try(module.cronitor.cronitor_id, "")
      alertmanager_opsgenie_integration_api_key : try(module.opsgenie.api_key, "")
      secret : random_string.secret.result
      suffix : random_string.suffix.result
      modules : local.aws_modules
      modules_output : local.aws_modules_output
    },
    module.teleport-agent.teleport_agent_config,
    var.manifests_template_vars
  )
}

module "cronitor" {
  source = "github.com/getupcloud/terraform-module-cronitor?ref=v1.4"

  api_endpoint      = module.cluster.cluster_endpoint
  cronitor_enabled  = var.cronitor_enabled
  cluster_name      = module.cluster.cluster_id
  cluster_sla       = var.cluster_sla
  customer_name     = var.customer_name
  suffix            = "eks"
  tags              = [var.region]
  pagerduty_key     = var.cronitor_pagerduty_key
  notification_list = var.cronitor_notification_list
}

module "opsgenie" {
  source = "github.com/getupcloud/terraform-module-opsgenie?ref=v1.2"

  opsgenie_enabled = var.opsgenie_enabled
  customer_name    = var.customer_name
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
