# Enhanced Monitoring용 IAM 역할
resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.enable_enhanced_monitoring ? 1 : 0

  name = "${var.environment}-${var.project_name}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.environment}-${var.project_name}-rds-monitoring-role"
  }
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count = var.enable_enhanced_monitoring ? 1 : 0

  role       = aws_iam_role.rds_enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# DB 파라미터 그룹
resource "aws_db_parameter_group" "this" {
  name   = "${var.environment}-${var.project_name}-${var.service_name}-db-parameter-group"
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.db_parameter
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-${var.service_name}-db-parameter-group"
  }
}

# Cluster 파라미터 그룹
resource "aws_rds_cluster_parameter_group" "this" {
  name   = "${var.environment}-${var.project_name}-${var.service_name}-db-cluster-parameter-group"
  family = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.cluster_parameter
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-${var.service_name}-db-cluster-parameter-group"
  }
}

# Aurora 클러스터
resource "aws_rds_cluster" "this" {
  count = var.engine_type == "aurora" ? 1 : 0

  cluster_identifier = "${var.environment}-${var.project_name}-${var.service_name}-cluster"
  engine             = var.aurora_engine
  engine_version     = var.aurora_engine_version
  engine_mode        = "provisioned"

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name

  master_username = var.master_username
  master_password = var.master_password

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.security_group_ids

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  storage_encrypted = var.enable_encryption
  kms_key_id        = var.kms_key_id != "" ? var.kms_key_id : null

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.final_snapshot_identifier_prefix}-${var.environment}-${var.project_name}-aurora-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  apply_immediately = var.apply_immediately

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  database_insights_mode          = var.database_insights_mode

  delete_automated_backups = var.delete_automated_backup_option

  tags = {
    Name = "${var.environment}-${var.project_name}-${var.service_name}-cluster"
  }

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

# Aurora 인스턴스
resource "aws_rds_cluster_instance" "this" {
  count = var.engine_type == "aurora" ? var.instance_count : 0

  identifier              = "${var.environment}-${var.project_name}-${var.service_name}-db${count.index + 1}"
  cluster_identifier      = aws_rds_cluster.this[0].id
  instance_class          = var.instance_class
  engine                  = aws_rds_cluster.this[0].engine
  engine_version          = aws_rds_cluster.this[0].engine_version
  db_parameter_group_name = aws_db_parameter_group.this.name

  publicly_accessible = var.publicly_accessible

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately

  # performance_insights_enabled          = var.enable_performance_insights
  # performance_insights_retention_period = var.enable_performance_insights ? var.performance_insights_retention_period : null

  monitoring_interval = var.enable_enhanced_monitoring ? var.monitoring_interval : 0
  monitoring_role_arn = var.enable_enhanced_monitoring ? aws_iam_role.rds_enhanced_monitoring[0].arn : null

  tags = {
    Name = "${var.environment}-${var.project_name}-${var.service_name}-db${count.index + 1}"
  }
}

# RDS MySQL 인스턴스
resource "aws_db_instance" "this" {
  count = var.engine_type == "rds" ? 1 : 0

  identifier     = "${var.environment}-${var.project_name}-rds"
  engine         = var.rds_engine
  engine_version = var.rds_engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage > 0 ? var.max_allocated_storage : null
  storage_type          = var.storage_type
  storage_encrypted     = var.enable_encryption
  kms_key_id            = var.kms_key_id != "" ? var.kms_key_id : null

  username = var.master_username
  password = var.master_password

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = var.security_group_ids

  multi_az            = var.multi_az
  publicly_accessible = var.publicly_accessible

  backup_retention_period = var.backup_retention_period
  backup_window           = var.preferred_backup_window
  maintenance_window      = var.preferred_maintenance_window

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.final_snapshot_identifier_prefix}-${var.environment}-${var.project_name}-rds-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  monitoring_interval = var.enable_enhanced_monitoring ? var.monitoring_interval : 0
  monitoring_role_arn = var.enable_enhanced_monitoring ? aws_iam_role.rds_enhanced_monitoring[0].arn : null

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = {
    Name        = "${var.environment}-${var.project_name}-rds"
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [final_snapshot_identifier]
  }
}

# 데이터베이스 자격 증명용 Secrets Manager 시크릿
resource "aws_secretsmanager_secret" "db_credentials" {
  count = var.create_secrets_manager_secret ? 1 : 0

  name        = "${var.environment}-${var.project_name}-db-credentials-${formatdate("YYYYMMDD-hhmmss", timestamp())}"
  description = "${var.engine_type == "aurora" ? "Aurora" : "RDS"} MySQL credentials for ${var.environment}"

  tags = {
    Name = "${var.environment}-${var.project_name}-db-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  count = var.create_secrets_manager_secret ? 1 : 0

  secret_id = aws_secretsmanager_secret.db_credentials[0].id
  secret_string = jsonencode({
    username        = var.master_username
    password        = var.master_password
    engine          = "mysql"
    host            = var.engine_type == "aurora" ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
    reader_endpoint = var.engine_type == "aurora" ? aws_rds_cluster.this[0].reader_endpoint : null
    port            = var.engine_type == "aurora" ? aws_rds_cluster.this[0].port : aws_db_instance.this[0].port
    identifier      = var.engine_type == "aurora" ? aws_rds_cluster.this[0].cluster_identifier : aws_db_instance.this[0].identifier
  })
}
