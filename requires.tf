terraform {
  required_providers {
    aws = {
      version = ">= 3.56.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1"
    }

    kubernetes = {
      version = "~> 2.8"
    }

    merge = {
      source  = "LukeCarrier/merge"
      version = "0.1.1"
    }

    opsgenie = {
      source  = "opsgenie/opsgenie"
      version = "~> 0.6"
    }

    random = {
      version = "~> 2"
    }

    shell = {
      source  = "scottwinkler/shell"
      version = "~> 1"
    }
  }
}
