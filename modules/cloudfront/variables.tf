# 필수 변수
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

# S3 Origin 설정
variable "s3_origin_domain_name" {
  description = "S3 bucket regional domain name for origin"
  type        = string
}

variable "s3_origin_id" {
  description = "Unique identifier for the S3 origin"
  type        = string
  default     = "S3Origin"
}

# 커스텀 도메인 설정
variable "aliases" {
  description = "Custom domain names (CNAMEs) for the distribution"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS (required if aliases are set)"
  type        = string
  default     = null
}

variable "default_ttl" {
  description = "Default TTL for cached objects (seconds)"
  type        = number
  default     = 86400 # 1 day
}

variable "max_ttl" {
  description = "Maximum TTL for cached objects (seconds)"
  type        = number
  default     = 31536000 # 1 year
}

variable "min_ttl" {
  description = "Minimum TTL for cached objects (seconds)"
  type        = number
  default     = 0
}

# 기타 설정
variable "enabled" {
  description = "Whether the distribution is enabled"
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether IPv6 is enabled"
  type        = bool
  default     = true
}

variable "http_version" {
  description = "Maximum HTTP version to support"
  type        = string
  default     = "http2and3"
}

variable "comment" {
  description = "Comment for the distribution"
  type        = string
  default     = null
}

# S3 버킷 정책용 변수
variable "s3_bucket_id" {
  description = "S3 bucket ID for OAC bucket policy"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN for OAC bucket policy"
  type        = string
}
