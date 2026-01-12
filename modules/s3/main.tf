# S3 버킷
resource "aws_s3_bucket" "this" {
  bucket        = "${var.environment}-${var.project_name}-${var.service_name}-bucket"
  force_destroy = var.force_destroy

  tags = {
    Name = "${var.environment}-${var.project_name}-${var.service_name}-bucket"
  }
}

# 버킷 버전 관리
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

# 서버 측 암호화 (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.enable_encryption ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
    bucket_key_enabled = true
  }
}

# 퍼블릭 액세스 차단
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
