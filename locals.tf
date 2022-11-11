locals {
  kubeconfig_filename        = abspath(pathexpand(module.cluster.kubeconfig_filename))
  api_endpoint               = module.cluster.cluster_endpoint
  token                      = data.aws_eks_cluster_auth.cluster.token
  certificate_authority_data = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)

  suffix = random_string.suffix.result
  secret = random_string.secret.result

  fargate_enabled = length(var.fargate_selectors) > 0 && length(var.fargate_private_subnet_ids) > 0 ? 1 : 0

  subnets = distinct(
    compact(
      flatten(
        concat(
          var.subnet_ids,
          [for i in var.node_groups : lookup(i, "subnet_ids", "")],
          var.fargate_private_subnet_ids
        )
      )
    )
  )

  auth_account_id = (var.auth_account_id == "self" ? data.aws_caller_identity.current.account_id : var.auth_account_id)

  cluster_endpoint_public_access_cidrs = (
    contains(var.endpoint_public_access_cidrs, "0.0.0.0/0")
    ? ["0.0.0.0/0"]
    : compact(concat(var.endpoint_public_access_cidrs, [module.internet.public_cidr_block]))
  )

  map_users = concat(
    [{
      userarn  = format("arn:aws:iam::%s:root", local.auth_account_id)
      username = var.auth_default_username
      groups   = var.auth_default_groups
    }],
    var.auth_map_users,
    [for user_id in var.auth_iam_users : {
      userarn  = format("arn:aws:iam::%s:user/%s", local.auth_account_id, user_id)
      username = var.auth_default_username
      groups   = var.auth_default_groups
    }]
  )

  # See https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1595
  map_roles = concat(
    [{
      rolearn  = format(module.cluster.worker_iam_role_arn)
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes"
      ]
    }],
    var.auth_map_roles,
    [for role in var.auth_iam_roles : {
      rolearn  = format("arn:aws:iam::%s:role/%s", local.auth_account_id, role)
      username = var.auth_default_username
      groups   = var.auth_default_groups
    }]
  )

  node_groups_additional_tags = merge(
    {
      "k8s.io/cluster-autoscaler/enabled"             = "TRUE"
      "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    },
    try(var.node_groups_defaults["additional_tags"], {})
  )

  node_groups_defaults = merge(
    {
      version  = var.kubernetes_version
      subnet   = local.subnets
      key_name = var.default_key_name
    },
    var.node_groups_defaults,
    {
      additional_tags = local.node_groups_additional_tags
    }
  )

  node_groups = { for name, node_group in var.node_groups : name => merge({
    desired_capacity = node_group.min_capacity
  }, node_group) }

  modules_result = {
    alb : merge(var.modules.alb, { output : var.modules.alb.enabled ? module.alb[0] : {} })
    kms : merge(var.modules.kms, { output : var.modules.kms.enabled ? module.kms[0] : {} })
    ebs_csi : merge(var.modules.ebs_csi, { output : var.modules.ebs_csi.enabled ? module.ebs_csi[0] : {} })
    efs : merge(var.modules.efs, { output : var.modules.efs.enabled ? module.efs[0] : {} })
    loki : merge(var.modules.loki, { output : var.modules.loki.enabled ? module.loki[0] : {} })
    velero : merge(var.modules.velero, { output : var.modules.velero.enabled ? module.velero[0] : {} })
    cluster-autoscaler : merge(var.modules.cluster-autoscaler, { output : var.modules.cluster-autoscaler.enabled ? module.cluster-autoscaler[0] : {} })
  }

  manifests_template_vars = merge(
    {
      alertmanager_cronitor_id : try(module.cronitor.cronitor_id, "")
      alertmanager_opsgenie_integration_api_key : try(module.opsgenie.api_key, "")
      secret : random_string.secret.result
      suffix : random_string.suffix.result
      modules : local.modules_result
    },
    module.teleport-agent.teleport_agent_config,
    var.manifests_template_vars
  )
}
