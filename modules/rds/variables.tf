variable "engine_type" {
  description = "Database engine type: aurora or rds"
  type        = string
  default     = "aurora"

  validation {
    condition     = contains(["aurora", "rds"], var.engine_type)
    error_message = "engine_type must be 'aurora' or 'rds'"
  }
}

variable "create_secrets_manager_secret" {
  description = "Whether to create Secrets Manager secret for credentials"
  type        = bool
  default     = false
}

variable "aurora_engine" {
  description = "Aurora engine"
  type        = string
  default     = "aurora-mysql"
}

variable "aurora_engine_version" {
  description = "Aurora MySQL engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.05.2"
}

variable "instance_class" {
  description = "Instance class for Aurora instances"
  type        = string
}

variable "instance_count" {
  description = "Number of Aurora instances (1 writer + N readers)"
  type        = number
  default     = 1
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
}

variable "master_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for Aurora"
  type        = list(string)
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "publicly_accessible" {
  description = "Whether the cluster is publicly accessible"
  type        = bool
  default     = false
}

variable "enable_encryption" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption (if not specified, default AWS key is used)"
  type        = string
  default     = ""
}

variable "database_insights_mode" {
  description = "Database Insights Mode"
  type        = string
  default     = "standard"
}

variable "enable_performance_insights" {
  description = "Enable Performance Insights"
  type        = bool
  default     = true
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention period in days"
  type        = number
  default     = 7
}

variable "enable_enhanced_monitoring" {
  description = "Enable Enhanced Monitoring"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval in seconds (0, 1, 5, 10, 15, 30, 60)"
  type        = number
  default     = 60
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier_prefix" {
  description = "Prefix for final snapshot identifier"
  type        = string
  default     = "final"
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Enable auto minor version upgrade"
  type        = bool
  default     = true
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

# RDS 전용 변수
variable "multi_az" {
  description = "Enable Multi-AZ deployment for RDS (not applicable to Aurora)"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "Allocated storage in GB for RDS (not applicable to Aurora)"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage for autoscaling in GB (0 to disable)"
  type        = number
  default     = 0
}

variable "storage_type" {
  description = "Storage type for RDS: gp2, gp3, io1"
  type        = string
  default     = "gp3"
}

variable "rds_engine" {
  description = "RDS engine"
  type        = string
}

variable "rds_engine_version" {
  description = "MySQL engine version for RDS (e.g., 8.0.35)"
  type        = string
  default     = "8.0.35"
}

variable "parameter_group_family" {
  description = "Parameter Group Family for RDS/Aurora"
  type        = string
}

variable "db_parameter" {
  description = "DB parameter group parameter"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate") # or "pending-reboot"
  }))
  default = []
}

variable "cluster_parameter" {
  description = "Cluster parameter group parameter"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate") # or "pending-reboot"
  }))
  default = []
}