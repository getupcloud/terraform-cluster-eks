resource "aws_eks_addon" "eks_addon" {
    for_each = { for b in var.eks_addon : try(b.addon_name, "${b.addon_name}") => b}
    cluster_name    = var.name
    addon_name   = try(each.value.addon_name)
    addon_version = try(each.value.addon_version)
    }       