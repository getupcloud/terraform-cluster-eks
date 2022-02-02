terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1"
    }

    random = {
      version = "~> 2"
    }

    aws = {
      version = ">= 3.56.0"
    }
  }
}
