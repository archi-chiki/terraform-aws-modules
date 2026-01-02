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

variable "alb_purpose" {
  description = "Purpose of ALB"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID where ALB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for ALB"
  type        = list(string)
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

# HTTPS 설정
variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener. If null, only HTTP listener is created"
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

# 타겟 그룹 (다중 지원)
variable "target_groups" {
  description = "Map of target group configurations"
  type = map(object({
    port                  = optional(number, 80)
    protocol              = optional(string, "HTTP")
    target_type           = optional(string, "instance")
    health_check_path     = optional(string, "/health")
    health_check_port     = optional(string, "traffic-port")
    healthy_threshold     = optional(number, 2)
    unhealthy_threshold   = optional(number, 2)
    health_check_interval = optional(number, 30)
    health_check_timeout  = optional(number, 5)
    health_check_matcher  = optional(string, "200")
  }))
  default = {}
}

# 리스너 기본 액션용 기본 타겟 그룹
variable "default_target_group_key" {
  description = "Key of the target group to use as default forward target"
  type        = string
}

# 리스너 규칙 (경로 기반 라우팅)
variable "listener_rules" {
  description = "Map of listener rule configurations for path-based routing"
  type = map(object({
    priority         = number
    path_patterns    = list(string)
    target_group_key = string
  }))
  default = {}
}

# ALB 설정
variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "Time in seconds that the connection is allowed to be idle"
  type        = number
  default     = 60
}

# 타겟 연결
variable "target_attachments" {
  description = "Map of target attachments (key = attachment identifier)"
  type = map(object({
    target_group_key = string
    target_id        = string
    port             = optional(number)
  }))
  default = {}
}
