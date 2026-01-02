output "instances" {
  description = "Map of all EC2 instance attributes"
  value = {
    for key, instance in aws_instance.this : key => {
      id                = instance.id
      arn               = instance.arn
      private_ip        = instance.private_ip
      public_ip         = instance.public_ip
      availability_zone = instance.availability_zone
    }
  }
}

output "instance_ids" {
  description = "Map of EC2 instance IDs"
  value       = { for key, instance in aws_instance.this : key => instance.id }
}

output "instance_private_ips" {
  description = "Map of private IP addresses"
  value       = { for key, instance in aws_instance.this : key => instance.private_ip }
}

output "instance_public_ips" {
  description = "Map of public IP addresses"
  value       = { for key, instance in aws_instance.this : key => instance.public_ip }
}

output "instance_arns" {
  description = "Map of EC2 instance ARNs"
  value       = { for key, instance in aws_instance.this : key => instance.arn }
}

output "instance_azs" {
  description = "Map of availability zones for instances"
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
