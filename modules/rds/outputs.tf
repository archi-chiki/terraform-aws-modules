output "id" {
  description = "ID of the Aurora cluster or RDS instance"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].id : aws_db_instance.this[0].id
}

output "arn" {
  description = "ARN of the Aurora cluster or RDS instance"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].arn : aws_db_instance.this[0].arn
}

output "identifier" {
  description = "Identifier of the Aurora cluster or RDS instance"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].cluster_identifier : aws_db_instance.this[0].identifier
}

output "endpoint" {
  description = "Primary endpoint (Aurora writer endpoint or RDS instance address)"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "reader_endpoint" {
  description = "Reader endpoint (Aurora only, null for RDS)"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "resource_id" {
  description = "Resource ID of the Aurora cluster or RDS instance"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].cluster_resource_id : aws_db_instance.this[0].resource_id
}

output "cluster_members" {
  description = "List of Aurora cluster members (Aurora only, null for RDS)"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].cluster_members : null
}

output "database_name" {
  description = "Name of the default database"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].database_name : aws_db_instance.this[0].db_name
  sensitive   = true
}

output "master_username" {
  description = "Master username for the database"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].master_username : aws_db_instance.this[0].username
  sensitive   = true
}

output "port" {
  description = "Port on which the database accepts connections"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].port : aws_db_instance.this[0].port
}

output "engine_version" {
  description = "Engine version of the database"
  value       = var.engine_type == "aurora" ? aws_rds_cluster.this[0].engine_version : aws_db_instance.this[0].engine_version
}

output "instance_ids" {
  description = "List of Aurora instance IDs (Aurora only, null for RDS)"
  value       = var.engine_type == "aurora" ? aws_rds_cluster_instance.this[*].id : null
}

output "instance_endpoints" {
  description = "List of Aurora instance endpoints (Aurora only, null for RDS)"
  value       = var.engine_type == "aurora" ? aws_rds_cluster_instance.this[*].endpoint : null
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret (null if not created)"
  value       = var.create_secrets_manager_secret ? aws_secretsmanager_secret.db_credentials[0].arn : null
}

output "secret_name" {
  description = "Name of the Secrets Manager secret (null if not created)"
  value       = var.create_secrets_manager_secret ? aws_secretsmanager_secret.db_credentials[0].name : null
}

output "engine_type" {
  description = "Database engine type (aurora or rds)"
  value       = var.engine_type
}
