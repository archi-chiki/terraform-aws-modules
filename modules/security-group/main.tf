resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = "${var.environment}-${var.project_name}-sg-${var.service_name}-${each.key}"
  description = each.value.description
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name = "${var.environment}-${var.project_name}-sg-${var.service_name}-${each.key}"
    },
    each.value.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "this" {
  for_each = var.security_group_rules

  security_group_id = aws_security_group.this[each.value.security_group_key].id
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  source_security_group_id = (
    each.value.source_security_group_key != null
    ? aws_security_group.this[each.value.source_security_group_key].id
    : null
  )
  description = each.value.description
}
