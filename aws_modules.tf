# Must register all modules in locals.tf

resource "local_file" "debug-modules" {
  count    = var.dump_debug ? 1 : 0
  filename = ".debug-eks-modules.json"
  content  = jsonencode(local.modules)
}

module "cluster-autoscaler" {
  count  = local.modules.cluster-autoscaler.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-eks-cluster-autoscaler?ref=v1.2"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "ebs-csi" {
  count  = local.modules.ebs-csi.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-ebs-csi?ref=v0.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "ecr" {
  count  = local.modules.ecr.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-ecr?ref=v1.0"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "efs" {
  count  = local.modules.efs.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-efs?ref=v1.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
}

module "velero" {
  count  = local.modules.velero.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-velero?ref=v1.7"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  bucket_name             = local.modules.velero.bucket_name
  tags                    = var.tags
}

module "thanos" {
  count  = local.modules.thanos.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-thanos?ref=v1.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "alb" {
  count  = local.modules.alb.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-alb?ref=v1.2"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
}

module "cert-manager" {
  count  = local.modules.cert-manager.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-cert-manager?ref=v2.0.0-alpha9"

  cluster_name  = module.cluster.cluster_id
  customer_name = var.customer_name
  provider_name = "aws"
  provider_aws = {
    hosted_zone_ids : local.modules.cert-manager.hosted_zone_ids
    cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
    service_account_namespace : "cert-manager"
    service_account_name : "cert-manager"
    tags : var.tags
  }
}

module "external-dns" {
  count  = local.modules.external-dns.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-external-dns?ref=v2.0.0"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  hosted_zone_ids         = local.modules.external-dns.hosted_zone_ids
}

module "kms" {
  count  = local.modules.kms.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-kms?ref=v1.1"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  key_id                  = local.modules.kms.key_id
  region                  = var.region
  account_id              = var.account_id
}

module "loki" {
  count  = local.modules.loki.enabled ? 1 : 0
  source = "github.com/getupcloud/terraform-module-aws-loki?ref=v1.3"

  cluster_name            = module.cluster.cluster_id
  cluster_oidc_issuer_url = module.cluster.cluster_oidc_issuer_url
  customer_name           = var.customer_name
  tags                    = var.tags
  region                  = var.region
  account_id              = var.account_id
}
