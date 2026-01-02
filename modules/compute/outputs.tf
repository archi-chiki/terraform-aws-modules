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

output "eip_public_ips" {
  description = "Map of EIP public IP addresses"
  value       = { for key, eip in aws_eip.this : key => eip.public_ip }
}

output "eip_allocation_ids" {
  description = "Map of EIP allocation IDs"
  value       = { for key, eip in aws_eip.this : key => eip.id }
}
