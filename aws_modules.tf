module "cluster-autoscaler" {
  source = "github.com/getupcloud/terraform-module-aws-eks-cluster-autoscaler?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "ecr" {
  count  = try(var.aws_modules.ecr, "enabled", false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-ecr?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "efs" {
  count  = try(var.aws_modules.efs, "enabled", false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-efs?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "velero" {
  count  = try(var.aws_modules.velero, "enabled", true) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-velero?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "thanos" {
  count  = try(var.aws_modules.thanos, "enabled", false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-thanos?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "alb" {
  count  = try(var.aws_modules.alb, "enabled", false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-alb?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "certmanager" {
  count  = try(var.aws_modules.certmanager, "enabled", true) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-certmanager?ref=main"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  hosted_zone             = var.hosted_zone
}

