variable "instances" {
  description = "EC2 instances configuration map"
  type = map(object({
    ami_id                = string
    instance_type         = string
    subnet_id             = string
    security_group_ids    = list(string)
    instance_profile_name = optional(string, null)
    root_volume_size      = optional(number, 20)
    root_volume_type      = optional(string, "gp3")
    key_name              = optional(string, null)
    user_data             = optional(string, "")
    associate_public_ip   = optional(bool, false)
    enable_eip            = optional(bool, false)
  }))
  default = {}
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
}