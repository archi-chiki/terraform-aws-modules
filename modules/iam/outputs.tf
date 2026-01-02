# IAM 역할 출력값
output "role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.this.name
}

output "role_id" {
  description = "ID of the IAM role"
  value       = aws_iam_role.this.id
}

# IAM 인스턴스 프로파일 출력값 (EC2용)
output "instance_profile_arn" {
  description = "ARN of the IAM instance profile (null if not created)"
  value       = var.create_instance_profile ? aws_iam_instance_profile.this[0].arn : null
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile (null if not created)"
  value       = var.create_instance_profile ? aws_iam_instance_profile.this[0].name : null
}
