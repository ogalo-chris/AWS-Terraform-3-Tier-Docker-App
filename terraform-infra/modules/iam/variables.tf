variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "project" {
  description = "Project name used for resource naming"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "secrets_arns" {
  description = "List of Secrets Manager ARNs EC2 instances can access"
  type        = list(string)
}
