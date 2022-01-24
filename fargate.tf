locals {
  fargate_name = "eks-fargate-${var.cluster_name}-${local.suffix}"
}

resource "aws_iam_role" "fargate" {
  count = local.fargate_enabled
  name  = local.fargate_name

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "fargate" {
  count      = local.fargate_enabled
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate[0].name
}

resource "aws_eks_fargate_profile" "fargate" {
  count                  = local.fargate_enabled
  cluster_name           = var.cluster_name
  fargate_profile_name   = local.fargate_name
  pod_execution_role_arn = aws_iam_role.fargate[0].arn
  subnet_ids             = var.fargate_private_subnet_ids

  dynamic "selector" {
    for_each = var.fargate_selectors

    content {
      namespace = selector.value.namespace
      labels    = lookup(selector.value, "labels", {})
    }
  }
}
