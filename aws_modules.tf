module "cluster-autoscaler" {
  count  = try(local.modules.cluster-autoscaler.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-eks-cluster-autoscaler?ref=v1.2"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "ebs_csi" {
  count  = try(local.modules.ebs_csi.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-ebs-csi?ref=v0.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "ecr" {
  count  = try(local.modules.ecr.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-ecr?ref=v1.0"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "efs" {
  count  = try(local.modules.efs.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-efs?ref=v1.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "velero" {
  count  = try(local.modules.velero.enabled, true) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-velero?ref=v1.7"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  bucket_name             = local.modules.velero.bucket_name
  tags                    = var.tags
}

module "thanos" {
  count  = try(local.modules.thanos.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-thanos?ref=v1.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "alb" {
  count  = try(local.modules.alb.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-alb?ref=v1.2"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "certmanager" {
  count  = try(local.modules.certmanager.enabled, true) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-certmanager?ref=v1.0"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  hosted_zone_ids         = try(local.modules.certmanager.hosted_zone_ids, [])

}

module "external-dns" {
  count  = try(local.modules.external-dns.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-external-dns?ref=v1.0"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  hosted_zone_ids         = try(local.modules.external-dns.hosted_zone_ids, [])
}

module "kms" {
  count  = try(local.modules.kms.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-kms?ref=v1.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  key_id                  = try(local.modules.kms.key_id, [])
  region                  = var.region
  account_id              = var.account_id
}

module "loki" {
  count  = try(local.modules.loki.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-loki?ref=v1.3"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  region                  = var.region
  account_id              = var.account_id
}
