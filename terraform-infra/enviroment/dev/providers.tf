terraform {
  required_version = ">= 1.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Latest major version (6.28.0 as of Jan 2026)
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7" # Latest stable version (3.7.2)
    }
  }

}

provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}