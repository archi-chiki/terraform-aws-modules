# Origin Access Control (S3용)
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.environment}-${var.project_name}-${var.service_name}-oac"
  description                       = "OAC for ${var.environment}-${var.project_name}-${var.service_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "this" {
  enabled         = var.enabled
  is_ipv6_enabled = var.is_ipv6_enabled
  http_version    = var.http_version
  comment         = "For ${var.environment}-${var.project_name}-${var.service_name}"
  aliases         = var.aliases

  # S3 Origin
  origin {
    domain_name              = var.s3_origin_domain_name
    origin_id                = var.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  # 기본 캐시 동작
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    compress               = true
  }

  # SSL/TLS 인증서 설정
  viewer_certificate {
    # 커스텀 도메인 사용 시 ACM 인증서
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = var.acm_certificate_arn != null ? "TLSv1.2_2021" : null
    cloudfront_default_certificate = var.acm_certificate_arn == null
  }

  # 지역 제한 (제한 없음)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-${var.service_name}-cf"
  }
}

# S3 버킷 정책 (OAC용)
resource "aws_s3_bucket_policy" "oac" {
  bucket = var.s3_bucket_id

  # CloudFront distribution이 먼저 생성되어야 ARN 참조 가능
  depends_on = [aws_cloudfront_distribution.this]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${var.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.this.arn
          }
        }
      }
    ]
  })
}
