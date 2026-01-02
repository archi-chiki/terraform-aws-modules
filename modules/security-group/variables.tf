variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
}

variable "service_name" {
  description = "Service name for resource naming and tagging"
  type        = string
}

variable "security_groups" {
  description = "Map of security group configurations"
  type = map(object({
    description = optional(string, "Managed by Terraform")
    tags        = optional(map(string), {})
  }))
  default = {}
}

variable "security_group_rules" {
  description = "Map of security group rules"
  type = map(object({
    security_group_key        = string
    type                      = string
    from_port                 = number
    to_port                   = number
    protocol                  = string
    cidr_blocks               = optional(list(string))
    source_security_group_key = optional(string)
    description               = optional(string, "Managed by Terraform")
  }))
  default = {}
}
