terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1"
    }

    kubernetes = {
      version = "~> 2.3.2"
    }

    random = {
      version = "~> 2"
    }

    aws = {
      version = ">= 3.56.0"
    }
  }
}
