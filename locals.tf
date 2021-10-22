locals {
  api_endpoint               = module.cluster.cluster_endpoint
  kubeconfig                 = abspath(pathexpand(module.cluster.kubeconfig_filename))
  certificate_authority_data = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                      = data.aws_eks_cluster_auth.cluster.token
  suffix                     = random_string.suffix.result
  secret                     = random_string.secret.result

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

  auth_account_id = (var.auth_account_id == "self"
    ? data.aws_caller_identity.current.account_id
    : var.auth_account_id
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
    }],
    [for role in var.auth_iam_roles : {
      userarn  = format("arn:aws:iam::%s:role/%s", local.auth_account_id, role)
      username = var.auth_default_username
      groups   = var.auth_default_groups
    }]
  )

  node_groups_defaults = merge({
    version  = var.kubernetes_version
    subnet   = local.subnets
    key_name = var.default_key_name
    additional_tags = {
      "k8s.io/cluster-autoscaler/enabled"     = "TRUE"
      "k8s.io/cluster-autoscaler/${var.name}" = "owned"
    }
  }, var.node_groups_defaults)

  node_groups = { for name, node_group in var.node_groups : name => merge({
    desired_capacity = node_group.min_capacity
  }, node_group) }
}