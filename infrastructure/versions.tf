terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "3.0.0"
    }
    ansible = {
      source = "nbering/ansible"
      version = "1.0.4"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}
