resource "aws_eks_addon" "eks_addon" {
  for_each          = var.eks_addons
  cluster_name      = module.eks.cluster_id
  addon_name        = each.key
  addon_version     = each.value.addon_version
  resolve_conflicts = try(each.value.resolve_conflicts, "OVERWRITE")
}
