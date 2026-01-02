output "security_group_ids" {
  description = "Map of security group IDs"
  value       = { for k, v in aws_security_group.this : k => v.id }
}

output "security_group_arns" {
  description = "Map of security group ARNs"
  value       = { for k, v in aws_security_group.this : k => v.arn }
}

# 하위 호환성을 위한 레거시 출력값
output "public_alb_security_group_id" {
  description = "ID of the ALB security group (deprecated: use security_group_ids[\"public_alb\"])"
  value       = try(aws_security_group.this["public_alb"].id, null)
}

output "app_security_group_id" {
  description = "ID of the app security group (deprecated: use security_group_ids[\"app\"])"
  value       = try(aws_security_group.this["app"].id, null)
}

output "backend_security_group_id" {
  description = "ID of the backend security group (deprecated: use security_group_ids[\"backend\"])"
  value       = try(aws_security_group.this["backend"].id, null)
}

output "aurora_security_group_id" {
  description = "ID of the Aurora security group (deprecated: use security_group_ids[\"aurora\"])"
  value       = try(aws_security_group.this["aurora"].id, null)
}

output "bastion_security_group_id" {
  description = "ID of the Bastion security group (deprecated: use security_group_ids[\"bastion\"])"
  value       = try(aws_security_group.this["bastion"].id, null)
}
