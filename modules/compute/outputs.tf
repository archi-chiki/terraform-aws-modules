output "instance_ids" {
  description = "Map of EC2 instance IDs"
  value       = { for key, instance in aws_instance.this : key => instance.id }
}

output "instance_arns" {
  description = "Map of EC2 instance ARNs"
  value       = { for key, instance in aws_instance.this : key => instance.arn }
}

output "instance_private_ips" {
  description = "Map of EC2 instance private IPs"
  value       = { for key, instance in aws_instance.this : key => instance.private_ip }
}

output "instance_public_ips" {
  description = "Map of EC2 instance public IPs"
  value       = { for key, instance in aws_instance.this : key => instance.public_ip }
}

output "instance_availability_zones" {
  description = "Map of EC2 instance availability zones"
  value       = { for key, instance in aws_instance.this : key => instance.availability_zone }
}

output "eip_public_ips" {
  description = "Map of EIP public IP addresses"
  value       = { for key, eip in aws_eip.this : key => eip.public_ip }
}

output "eip_allocation_ids" {
  description = "Map of EIP allocation IDs"
  value       = { for key, eip in aws_eip.this : key => eip.id }
}
