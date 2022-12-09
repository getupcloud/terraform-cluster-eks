## This file is auto-generated by command:
## $ ./make-modules variables-modules.tf

locals {
  modules = {
    alb = {
      enabled      = try(var.modules.alb.enabled, var.modules_defaults.alb.enabled)
      ingressClass = try(var.modules.alb.ingressClass, var.modules_defaults.alb.ingressClass)
    }
    cert-manager = {
      enabled         = try(var.modules.cert-manager.enabled, var.modules_defaults.cert-manager.enabled)
      hosted_zone_ids = try(var.modules.cert-manager.hosted_zone_ids, var.modules_defaults.cert-manager.hosted_zone_ids)
    }
    cluster-autoscaler = {
      enabled = try(var.modules.cluster-autoscaler.enabled, var.modules_defaults.cluster-autoscaler.enabled)
    }
    ebs-csi = {
      enabled = try(var.modules.ebs-csi.enabled, var.modules_defaults.ebs-csi.enabled)
    }
    ecr = {
      enabled = try(var.modules.ecr.enabled, var.modules_defaults.ecr.enabled)
    }
    efs = {
      enabled        = try(var.modules.efs.enabled, var.modules_defaults.efs.enabled)
      file_system_id = try(var.modules.efs.file_system_id, var.modules_defaults.efs.file_system_id)
    }
    external-dns = {
      enabled         = try(var.modules.external-dns.enabled, var.modules_defaults.external-dns.enabled)
      private         = try(var.modules.external-dns.private, var.modules_defaults.external-dns.private)
      hosted_zone_ids = try(var.modules.external-dns.hosted_zone_ids, var.modules_defaults.external-dns.hosted_zone_ids)
      domain_filters  = try(var.modules.external-dns.domain_filters, var.modules_defaults.external-dns.domain_filters)
    }
    kms = {
      enabled = try(var.modules.kms.enabled, var.modules_defaults.kms.enabled)
      key_id  = try(var.modules.kms.key_id, var.modules_defaults.kms.key_id)
    }
    loki = {
      enabled = try(var.modules.loki.enabled, var.modules_defaults.loki.enabled)
    }
    thanos = {
      enabled = try(var.modules.thanos.enabled, var.modules_defaults.thanos.enabled)
    }
    velero = {
      enabled     = try(var.modules.velero.enabled, var.modules_defaults.velero.enabled)
      bucket_name = try(var.modules.velero.bucket_name, var.modules_defaults.velero.bucket_name)
    }
  }
}
