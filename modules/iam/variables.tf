# 필수 변수
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "role_name" {
  description = "Name suffix for the IAM role (e.g., ec2-app, lambda-api)"
  type        = string
}

variable "role_description" {
  description = "Description of the IAM role"
  type        = string
  default     = "Managed by Terraform"
}

variable "trusted_services" {
  description = "List of AWS services that can assume this role"
  type        = list(string)
  # 예시:
  # - EC2: ["ec2.amazonaws.com"]
  # - Lambda: ["lambda.amazonaws.com"]
  # - ECS Tasks: ["ecs-tasks.amazonaws.com"]
  # - 복수 서비스: ["ec2.amazonaws.com", "lambda.amazonaws.com"]
}

# 선택 변수
variable "managed_policy_arns" {
  description = "List of AWS managed policy ARNs to attach"
  type        = list(string)
  default     = []
  # 예시:
  # - "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  # - "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  # - "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

variable "custom_policy" {
  description = "Custom IAM policy document in JSON format"
  type        = string
  default     = null
  # 예시:
  # custom_policy = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Effect   = "Allow"
  #       Action   = ["s3:GetObject"]
  #       Resource = ["arn:aws:s3:::my-bucket/*"]
  #     }
  #   ]
  # })
}

variable "create_instance_profile" {
  description = "Whether to create an IAM instance profile (for EC2)"
  type        = bool
  default     = false
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds (3600-43200)"
  type        = number
  default     = 3600
}
