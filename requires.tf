terraform {
  required_providers {
    cronitor = {
      source  = "nauxliu/cronitor"
      version = "~> 1"
    }

    shell = {
      source  = "scottwinkler/shell"
      version = "~> 1"
    }

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

    kubernetes = {
      version = "~> 2.3.2"
    }
  }
}
