output "ec2_role_name" {
  description = "IAM role name assumed by EC2 instances"
  value       = aws_iam_role.ec2_role.name
}

output "ec2_role_arn" {
  description = "IAM role ARN assumed by EC2 instances"
  value       = aws_iam_role.ec2_role.arn
}

output "instance_profile_name" {
  description = "IAM instance profile name for EC2 or ASG"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "instance_profile_arn" {
  description = "IAM instance profile ARN"
  value       = aws_iam_instance_profile.ec2_profile.arn
}
