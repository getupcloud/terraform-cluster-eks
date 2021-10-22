output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster."
  value = module.cluster.cluster_iam_role_arn
}
