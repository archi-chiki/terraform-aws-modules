# 애플리케이션 로드 밸런서
resource "aws_lb" "this" {
  name = "${var.environment}-${var.project_name}-alb-${var.service_name}${var.alb_purpose != null ? "-${var.alb_purpose}" : ""}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  idle_timeout                     = var.idle_timeout

  tags = {
    Name = "${var.environment}-${var.project_name}-alb-${var.service_name}${var.alb_purpose != null ? "-${var.alb_purpose}" : ""}"
  }
}

# 타겟 그룹
resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name        = "${var.environment}-${var.project_name}-tg-${var.service_name}-${each.key}"
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = each.value.target_type

  health_check {
    enabled             = true
    path                = each.value.health_check_path
    protocol            = each.value.protocol
    port                = each.value.health_check_port
    interval            = each.value.health_check_interval
    timeout             = each.value.health_check_timeout
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
    matcher             = each.value.health_check_matcher
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-${each.key}-tg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# HTTP 리스너
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = var.certificate_arn != null ? "redirect" : "forward"

    # 인증서가 있을 경우 HTTPS로 리다이렉트
    dynamic "redirect" {
      for_each = var.certificate_arn != null ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    # 인증서가 없을 경우 기본 타겟 그룹으로 포워딩
    target_group_arn = var.certificate_arn == null ? aws_lb_target_group.this[var.default_target_group_key].arn : null
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-http-listener"
  }
}

# HTTPS 리스너 (조건부 생성)
resource "aws_lb_listener" "https" {
  count = var.certificate_arn != null ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[var.default_target_group_key].arn
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-https-listener"
  }
}

# 리스너 규칙 (경로 기반 라우팅)
resource "aws_lb_listener_rule" "this" {
  for_each = var.listener_rules

  # HTTPS 리스너가 있으면 HTTPS에 연결, 없으면 HTTP에 연결
  listener_arn = var.certificate_arn != null ? aws_lb_listener.https[0].arn : aws_lb_listener.http.arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }

  condition {
    path_pattern {
      values = each.value.path_patterns
    }
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-${each.key}-rule"
  }
}

# 타겟 그룹 연결
resource "aws_lb_target_group_attachment" "this" {
  for_each = var.target_attachments

  target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  target_id        = each.value.target_id
  port             = each.value.port != null ? each.value.port : var.target_groups[each.value.target_group_key].port
}
