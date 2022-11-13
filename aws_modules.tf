# Must register all modules in locals.tf

module "cluster-autoscaler" {
  count  = try(var.modules.cluster-autoscaler.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-eks-cluster-autoscaler?ref=v1.2"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "ebs-csi" {
  count  = try(var.modules.ebs-csi.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-ebs-csi?ref=v0.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "ecr" {
  count  = try(var.modules.ecr.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-ecr?ref=v1.0"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "efs" {
  count  = try(var.modules.efs.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-efs?ref=v1.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "velero" {
  count  = try(var.modules.velero.enabled, true) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-velero?ref=v1.7"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  bucket_name             = var.modules.velero.bucket_name
  tags                    = var.tags
}

module "thanos" {
  count  = try(var.modules.thanos.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-thanos?ref=v1.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "alb" {
  count  = try(var.modules.alb.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-alb?ref=v1.2"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "cert-manager" {
  count  = try(var.modules.cert-manager.enabled, true) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-cert-manager?ref=v1.0.3"

  cluster_name  = module.cluster.cluster_id
  customer_name = var.customer_name
  dns_provider  = "aws"
  dns_provider_aws = {
    hosted_zone_ids : try(var.modules.certmanager.hosted_zone_ids, [])
    cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
    service_account_namespace : "cert-manager"
    service_account_name : "cert-manager"
    tags : var.tags
  }
}

module "external-dns" {
  count  = try(var.modules.external-dns.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-external-dns?ref=v1.0"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  hosted_zone_ids         = try(var.modules.external-dns.hosted_zone_ids, [])
}

module "kms" {
  count  = try(var.modules.kms.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-kms?ref=v1.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  key_id                  = try(var.modules.kms.key_id, [])
  region                  = var.region
  account_id              = var.account_id
}

module "loki" {
  count  = try(var.modules.loki.enabled, false) ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-loki?ref=v1.3"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  region                  = var.region
  account_id              = var.account_id
}
