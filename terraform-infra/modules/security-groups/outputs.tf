output "public_alb_sg_id" {
  description = "Security group ID for public ALB"
  value       = aws_security_group.public_alb.id
}

output "internal_alb_sg_id" {
  description = "Security group ID for internal ALB"
  value       = aws_security_group.internal_alb.id
}

output "frontend_sg_id" {
  description = "Security group ID for frontend app servers"
  value       = aws_security_group.frontend.id
}

output "backend_sg_id" {
  description = "Security group ID for backend app servers"
  value       = aws_security_group.backend.id
}

output "rds_sg_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.rds.id
}

output "bastion_sg_id" {
  description = "Security group ID for bastion host"
  value       = aws_security_group.bastion.id
}