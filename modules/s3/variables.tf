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

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Allow bucket deletion even with objects inside"
  type        = bool
  default     = false
}

variable "enable_encryption" {
  description = "Enable server-side encryption with SSE-S3"
  type        = bool
  default     = true
}
