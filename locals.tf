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

  auth_account_id = (var.auth_account_id == "self" ? data.aws_caller_identity.current.account_id : var.auth_account_id
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

  ## TODO: alb, kms, velero, cluster-autoscaler, ecr-sync (https://github.com/getupcloud/helm-charts/tree/main/charts/ecr-credentials-sync)
  irsa_arn_template_vars = {
    kustomize_controller_irsa_arn : (local.aws_modules.kms.enabled ? module.kms[0].iam_role_arn : ""),
    loki_irsa_arn : (local.aws_modules.loki.enabled ? module.loki[0].iam_role_arn : ""),
    # aws_eks_efs_irsa_arn : "(local.aws_modules.efs.enabled ? module.efs[0].iam_role_arn : )"
  }

  aws_modules = merge(var.aws_modules_defaults, var.aws_modules)
  aws_modules_output = {
    alb : local.aws_modules.alb.enabled ? module.alb[0] : {},
    kms : local.aws_modules.kms.enabled ? module.kms[0] : {},
    efs : local.aws_modules.efs.enabled ? module.efs[0] : {},
    loki : local.aws_modules.loki.enabled ? module.loki[0] : {},
  }
}
