variable "project" {
    description = "The project to deploy to"
    default     = ""
    type = string
  
}

variable "environment" {
    description = "deployment environment (e.g. dev, staging, prod)"
    type = string
  }

variable "vpc_id" {
    description = "The VPC ID where the security groups will be created"
    type        = string
  }

variable "tags" {
    description = "A map of tags to add to all resources"
    type        = map(string)
    default     = {}
  }

variable "bastion_allowed_ips" {
  description = "A list of allowed IPs to access the jump server"
  type = list(string)
}