variable "cidr_block" {
  type        = string
  description = "VPC CIDR block"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "public_subnet_azs" {
  type = list(string)
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_azs" {
  type = list(string)
}

variable "private_frontend_cidr" {
  type = list(string)
}

variable "private_backend_cidr" {
  type = list(string)
}

variable "private_database_cidr" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}