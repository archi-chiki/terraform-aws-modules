output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.this.private_ip
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "instance_availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.this.availability_zone
}

output "eip_public_ip" {
  description = "EIP public IP address (null if EIP is not enabled)"
  value       = var.enable_eip ? aws_eip.this[0].public_ip : null
}

output "eip_allocation_id" {
  description = "EIP allocation ID (null if EIP is not enabled)"
  value       = var.enable_eip ? aws_eip.this[0].id : null
}
