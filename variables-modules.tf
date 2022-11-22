## Provider-specific modules variables
## Copy to toplevel

variable "modules_defaults" {
  description = "Configure AWS modules to install (defaults)"
  type = object({
    alb = object({
      enabled      = bool
      ingressClass = string
    })
    cert-manager = object({
      enabled         = bool
      hosted_zone_ids = list(string)
    })
    cluster-autoscaler = object({ enabled = bool })
    ebs-csi            = object({ enabled = bool })
    ecr                = object({ enabled = bool })
    efs = object({
      enabled        = bool
      file_system_id = string
    })
    external-dns = object({
      enabled         = bool
      private         = bool
      hosted_zone_ids = list(string)
      domain_filters  = list(string)
    })
    kms = object({
      enabled = bool
      key_id  = string
    })
    loki   = object({ enabled = bool })
    thanos = object({ enabled = bool })
    velero = object({
      enabled     = bool
      bucket_name = string
    })
  })

  default = {
    alb = {
      enabled      = true
      ingressClass = "alb"
    }
    cert-manager = {
      enabled         = false
      hosted_zone_ids = []
    }
    cluster-autoscaler = {
      enabled = true
    }
    ebs-csi = {
      enabled = true
    }
    ecr = {
      enabled = false
    }
    efs = {
      enabled        = false
      file_system_id = ""
    }
    external-dns = {
      enabled         = false
      private         = false
      hosted_zone_ids = []
      domain_filters  = []
    }
    kms = {
      enabled = false
      key_id  = ""
    }
    loki = {
      enabled = true
    }
    thanos = {
      enabled = false
    }
    velero = {
      enabled     = true
      bucket_name = ""
    }
  }
}

locals {
  modules = merge(var.modules_defaults, var.modules, {
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
  })

  register_modules = {
    alb : local.modules.alb.enabled ? module.alb[0] : {}
    cert-manager : local.modules.cert-manager.enabled ? module.cert-manager[0] : {}
    cluster-autoscaler : local.modules.cluster-autoscaler.enabled ? module.cluster-autoscaler[0] : {}
    ebs-csi : local.modules.ebs-csi.enabled ? module.ebs-csi[0] : {}
    ecr : local.modules.ecr.enabled ? module.ecr[0] : {}
    efs : local.modules.efs.enabled ? module.efs[0] : {}
    external-dns : local.modules.external-dns.enabled ? module.external-dns[0] : {}
    kms : local.modules.kms.enabled ? module.kms[0] : {}
    loki : local.modules.loki.enabled ? module.loki[0] : {}
    thanos : local.modules.thanos.enabled ? module.thanos[0] : {}
    velero : local.modules.velero.enabled ? module.velero[0] : {}
  }
}
