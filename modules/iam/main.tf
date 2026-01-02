# IAM 역할
resource "aws_iam_role" "this" {
  name        = var.role_name
  description = var.role_description

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.trusted_services
        }
      }
    ]
  })

  max_session_duration = var.max_session_duration

  tags = {
    Name = var.role_name
  }
}

# AWS 관리형 정책 연결
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# 커스텀 인라인 정책
resource "aws_iam_role_policy" "custom" {
  count = var.custom_policy != null ? 1 : 0

  name   = "${var.environment}-${var.project_name}-policy-${var.role_name}"
  role   = aws_iam_role.this.id
  policy = var.custom_policy
}

# IAM 인스턴스 프로파일 (EC2용)
resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = "${var.environment}-${var.project_name}-profile-${var.role_name}"
  role = aws_iam_role.this.name

  tags = {
    Name = "${var.environment}-${var.project_name}-profile-${var.role_name}"
  }
}
