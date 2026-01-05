# EC2 인스턴스
resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = var.associate_public_ip

  user_data = var.user_data != "" ? base64encode(var.user_data) : null

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "${var.environment}-${var.project_name}-${var.instance_name}-volume"
    }
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-${var.instance_name}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ami, user_data, associate_public_ip_address]
  }
}

# Elastic IP (조건부 생성)
resource "aws_eip" "this" {
  count = var.enable_eip ? 1 : 0

  domain = "vpc"

  tags = {
    Name = "${var.environment}-${var.project_name}-${var.instance_name}-eip"
  }
}

resource "aws_eip_association" "this" {
  count = var.enable_eip ? 1 : 0

  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this[0].id
}
