terraform {
  backend "s3" {
    bucket  = "vpc-terraform-state-491085397373"
    key     = "AWS-Terraform-3-Tier-Docker-App/dev/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}
