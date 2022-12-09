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
