#############################
## AWS configs
#############################

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
}
variable "aws_secret_access_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.21"
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_id" {
  description = "AWS VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "AWS VPC subnet IDs. Applies to all node_groups by default."
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Creates public EKS endpoint"
  type        = bool
  default     = true
}

variable "endpoint_public_access_cidrs" {
  description = "List of CIDRs to allow access to EKS private endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "endpoint_private_access" {
  description = "Creates private EKS endpoint"
  type        = bool
  default     = true
}

variable "endpoint_private_access_cidrs" {
  description = "List of CIDRs to allow access to EKS public endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vpc_cni_k8s_url" {
  description = "URL to Amazon VPC CNI K8S manifests"
  type        = string
  default     = "https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/v1.7.5/config/v1.7/calico.yaml"
}

variable "metrics_server_url" {
  description = "URL to Metrics Server deployment"
  type        = string
  default     = "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
}

#############################
## Node Groups
#############################

## https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/node_groups
variable "node_groups_defaults" {
  description = "AWS EKS default node_groups definition"
  type        = any
  default = {
    instance_types   = ["m5.xlarge"]
    desired_capacity = 1
    min_capacity     = 1
    max_capacity     = 1
    disk_size        = 50
    additional_tags  = {}
  }
}

## https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/node_groups
variable "node_groups" {
  description = "AWS EKS node_groups definition"
  type        = any
  default = {
    "infra" : {
      "min_capacity" : 2,
      "max_capacity" : 2,
      "k8s_labels" : {
        "role" : "infra"
      },
      "taints" : [
        {
          "key" : "dedicated"
          "value" : "infra"
          "effect" : "NO_SCHEDULE"
        }
      ]
    },
    "app" : {
      "min_capacity" : 2,
      "max_capacity" : 4,
      "k8s_labels" : {
        "role" : "app"
      }
    }
  }
}

variable "default_key_name" {
  description = "Key name for workers. Applies to all node groups"
  type        = string
  default     = ""
}

variable "default_iam_role_arn" {
  description = "ARN of the default IAM worker role to use if none is specified neither in `var.node_groups` nor `var.node_groups_defaults`"
  type        = string
  default     = ""
}

variable "aws_modules" {
  default = {
    "certmanager" : {
      "enabled" : true
    }
    "cluster-autoscaler" : {
      "enabled" : true
    }
    "velero" : {
      "enabled" : true
    }
    "ecr" : {
      "enabled" : false
    }
    "efs" : {
      "enabled" : false
    }
    "thanos" : {
      "enabled" : false
    }
    "alb" : {
      "enabled" : false
    }
  }
}

#############################
## Fargate
#############################

## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile
## Example: [
##   {
##     namespace: "my-api",
##     labels: {
##       app: "api",
##       release: "1.0"
##     }
##   }
## ]
variable "fargate_selectors" {
  description = "EKS Fargate selectors"
  type        = any
  default     = []

}

variable "fargate_private_subnet_ids" {
  description = "EKS Fargate subnet IDs"
  type        = list(string)
  default     = []
}

#############################
## IAM Authentication
#############################

# Variables `auth_*`: auto-gen IAM->EKS auth users mapping as defined by:
# {
#   "userarn": "arn:aws:iam::${auth_account_id}:user/${auth_iam_users[*]}",
#   "username": ${auth_default_username},
#   "groups": ${auth_default_groups}
# }
#
# Concatenates with `auth_map_users` below

variable "auth_account_id" {
  description = "AWS AccountId for IAM ARN users. Use `self` for EKS account ID."
  type        = string
  default     = "self"
}

variable "auth_iam_users" {
  description = "List of IAM users to allow kubernetes access."
  type        = list(string)
  default     = []
}

variable "auth_iam_roles" {
  description = "List of IAM roles to allow kubernetes access."
  type        = list(string)
  default     = ["getupcloud"]
}

variable "auth_default_username" {
  description = "Kubernetes username assumed by IAM users."
  type        = string
  default     = "admin"
}

variable "auth_default_groups" {
  description = "Kubernetes groups assumed by IAM users."
  type        = list(string)
  default     = ["system:masters"]
}

# Hardcoded IAM->EKS auth users mapping.
# Passed as-is to EKS map_users configmap.
# Concatenates with `auth_*` above.

variable "auth_map_users" {
  description = "EKS ConfigMap aws-auth according to https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html"
  type = list(object({
    userarn : string
    username : string
    groups : list(string)
  }))
  default = []
}

variable "auth_map_roles" {
  description = "EKS ConfigMap aws-auth according to https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html"
  type = list(object({
    rolearn : string
    username : string
    groups : list(string)
  }))
  default = []
}

variable "s3_buckets" {
  description = "List of Space Buckets (See s3.tf for defaults)"
  type        = any
  default     = []
}

variable "db_rds" {
  description = "List RDS (See rds.tf for defaults)"
  type        = any
  default     = []
}
variable "cluster_rds" {
  description = "List Cluster RDS (See rds.tf for defaults)"
  type        = any
  default     = []
}
variable "db_subnet_group" {
  description = "List subnet group RDS (See rds.tf for defaults)"
  type        = any
  default     = []
}

variable "local_exec" {
  description = "Exec scripts"
  type        = any
  default     = []
}

variable "eks_addons" {
  description = "Manages an EKS add-on"
  type        = any
  default     = {}

  # Example:
  # {
  #   "vpc-cni": {
  #     "addon_version": "v1.9.0-eksbuild.1",  ## required
  #     "resolve_conflicts": "OVERWRITE"       ## default
  #   }
  # }
}
