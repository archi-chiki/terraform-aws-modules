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

variable "sse_algorithm" {
  description = "S3 SSE Algorithm"
  type        = string
  default     = "AES256"
}

variable "block_public_acls" {
  description = "Block public access to the bucket"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public access to the bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public access to the bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public access to the bucket"
  type        = bool
  default     = true
}