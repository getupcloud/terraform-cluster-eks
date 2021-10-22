data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = module.cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_id
}

data "iam_role_arn" "workers" {
  name = module.cluster.aws_iam_role

} 