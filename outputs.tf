output "cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready."
  value       = module.cluster.cluster_id
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster."
  value       = module.cluster.cluster_iam_role_arn
}

output "worker_iam_role_arn" {
  description = "IAM role ARN for EKS worker groups"
  value       = module.cluster.worker_iam_role_arn
}

output "fargate_iam_role_arn" {
  description = "IAM role ARN for EKS Fargate pods"
  value       = module.cluster.fargate_iam_role_arn
}

output "worker_security_group_id" {
  description = "Security group ID attached to the EKS workers."
  value       = module.cluster.worker_security_group_id
}

output "kubeconfig_filename" {
  description = "The filename of the generated kubectl config. Will block on cluster creation until the cluster is really ready."
  value       = module.cluster.kubeconfig_filename
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = module.cluster.cluster_oidc_issuer_url
}
  
output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster. On 1.14 or later, this is the 'Additional security groups' in the EKS console."
  value       = module.cluster_security_group_id
}
  
output "suffix" {
  description = "Random suffix for this cluster"
  value       = random_string.suffix
}

output "secret" {
  description = "Random secret for this cluster"
  value       = random_string.secret
}
