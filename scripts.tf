resource "shell_script" "pre_create" {
  for_each = toset(concat(var.pre_create, var.eks_pre_create))

  lifecycle_commands {
    create = each.value
    read   = "echo {}"
    update = each.value
    delete = "echo {}"
  }

  environment = {}
}

resource "shell_script" "post_create" {
  for_each = toset(concat(var.post_create, var.eks_post_create))

  lifecycle_commands {
    create = each.value
    read   = "echo {}"
    update = each.value
    delete = "echo {}"
  }

  environment = {}

  depends_on = [
    module.cluster.cluster_id
  ]
}
