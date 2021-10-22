module "internet" {
  source = "github.com/getupcloud/terraform-module-internet?ref=main"
}

module "cluster" {
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 17.1"

  create_eks      = true
  cluster_name    = var.name
  cluster_version = var.kubernetes_version
  vpc_id          = var.vpc_id
  map_users       = local.map_users
  subnets         = local.subnets
  enable_irsa     = true

  node_groups          = local.node_groups
  node_groups_defaults = local.node_groups_defaults

  cluster_endpoint_public_access = var.endpoint_public_access
  cluster_endpoint_public_access_cidrs = compact(concat(
    var.endpoint_public_access_cidrs, [
      module.internet.public_cidr_block
    ]
  ))

  cluster_endpoint_private_access       = var.endpoint_private_access
  cluster_endpoint_private_access_cidrs = var.endpoint_private_access_cidrs

  tags = merge({
    Name = var.name
    Role = "eks-cluster"
  }, var.tags)
}

module "flux" {
  source = "github.com/getupcloud/terraform-module-flux?ref=main"

  git_repo       = var.flux_git_repo
  manifests_path = "./clusters/${var.name}/eks/manifests"
  wait           = var.flux_wait
}

module "cluster-autoscaler" {
  source = "github.com/getupcloud/terraform-module-aws-eks-cluster-autoscaler?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "ecr" {
  source = "github.com/getupcloud/terraform-module-aws-ecr?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "efs" {
  source = "github.com/getupcloud/terraform-module-aws-efs?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "velero" {
  source = "github.com/getupcloud/terraform-module-aws-velero?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "thanos" {
  source = "github.com/getupcloud/terraform-module-aws-thanos?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "alb" {
  source = "github.com/getupcloud/terraform-module-aws-alb?ref=main"
  #verificacao para instalar 
  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}
module "certmanager" {
  source = "github.com/getupcloud/terraform-module-aws-certmanager?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  hosted_zone             = var.hosted_zone
}
