# EC2 인스턴스
resource "aws_instance" "this" {
  for_each = var.instances

  ami                         = each.value.ami_id
  instance_type               = each.value.instance_type
  key_name                    = each.value.key_name
  subnet_id                   = each.value.subnet_id
  vpc_security_group_ids      = each.value.security_group_ids
  iam_instance_profile        = each.value.instance_profile_name
  associate_public_ip_address = each.value.associate_public_ip

  user_data = each.value.user_data != "" ? base64encode(each.value.user_data) : null

  root_block_device {
    volume_type           = each.value.root_volume_type
    volume_size           = each.value.root_volume_size
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "${var.environment}-${var.project_name}-${each.key}-volume"
    }
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-${each.key}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ami, user_data, associate_public_ip_address]
  }
}

# enable_eip = true인 인스턴스용 Elastic IP
resource "aws_eip" "this" {
  for_each = { for k, v in var.instances : k => v if v.enable_eip }

  domain = "vpc"

  tags = {
    Name = "${var.environment}-${var.project_name}-${each.key}-eip"
  }
}

resource "aws_eip_association" "this" {
  for_each = aws_eip.this

  instance_id   = aws_instance.this[each.key].id
  allocation_id = each.value.id
}