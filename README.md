# Terraform AWS Modules

AWS 인프라를 위한 재사용 가능한 Terraform 모듈 라이브러리입니다.

## 요구사항

| 구성 요소 | 버전         |
|-----------|------------|
| Terraform | >= 1.13.0  |
| AWS Provider | >= 5.100.0 |

### AWS 자격증명 설정

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_REGION="your-aws-region"
```

## 프로젝트 구조

```
terraform-aws-modules/
└── modules/
    ├── vpc/              # VPC 및 네트워크 인프라
    ├── security-group/   # 보안 그룹
    ├── alb/              # Application Load Balancer
    ├── compute/          # EC2 인스턴스
    ├── rds/              # Aurora/RDS 데이터베이스
    ├── s3/               # S3 버킷
    ├── cloudfront/       # CloudFront CDN
    └── iam/              # IAM 역할 및 정책
```

## 모듈 상세

### vpc

VPC 및 네트워크 인프라를 구성합니다.

**주요 리소스**:
- VPC, Internet Gateway
- Public/Private/DB 서브넷
- NAT Gateway (선택 사항)
- Route Tables
- DB Subnet Group

**주요 변수**:

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `vpc_cidr` | VPC CIDR 블록 | - |
| `public_subnet_cidrs` | 퍼블릭 서브넷 CIDR 목록 | - |
| `private_subnet_cidrs` | 프라이빗 서브넷 CIDR 목록 | - |
| `db_subnet_cidrs` | DB 서브넷 CIDR 목록 | - |
| `availability_zones` | 가용 영역 목록 | - |
| `enable_nat_gateway` | NAT Gateway 활성화 | `false` |

**출력값**: `vpc_id`, `public_subnet_ids`, `private_subnet_ids`, `db_subnet_ids`, `db_subnet_group_name`

**사용 예제**:

```hcl
module "vpc" {
  source = "github.com/terraform-aws-modules/modules/vpc?ref=<Release Version>"

  environment    = "dev"
  project_name   = "myapp"
  service_name   = "network"
  vpc_cidr       = "10.0.0.0/16"

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  db_subnet_cidrs      = ["10.0.21.0/24", "10.0.22.0/24"]
  availability_zones   = ["ap-northeast-2a", "ap-northeast-2c"]

  enable_nat_gateway = true
}
```

---

### security-group

보안 그룹 및 규칙을 관리합니다.

**주요 리소스**:
- Security Groups
- Security Group Rules

**주요 변수**:

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `vpc_id` | VPC ID | - |
| `security_groups` | 보안 그룹 정의 (map) | - |
| `security_group_rules` | 보안 그룹 규칙 정의 (map) | - |

**출력값**: `security_group_ids`, `security_group_arns`

**사용 예제**:

```hcl
module "security_group" {
  source = "github.com/terraform-aws-modules/modules/security-group?ref=<Release Version>"

  vpc_id = module.vpc.vpc_id

  security_groups = {
    alb = { description = "ALB Security Group" }
    app = { description = "Application Security Group" }
  }

  security_group_rules = {
    alb_http = {
      security_group_key = "alb"
      type               = "ingress"
      from_port          = 80
      to_port            = 80
      protocol           = "tcp"
      cidr_blocks        = ["0.0.0.0/0"]
    }
    app_from_alb = {
      security_group_key        = "app"
      type                      = "ingress"
      from_port                 = 8080
      to_port                   = 8080
      protocol                  = "tcp"
      source_security_group_key = "alb"
    }
  }
}
```

---

### alb

Application Load Balancer를 구성합니다.

**주요 리소스**:
- Application Load Balancer
- Target Groups
- HTTP/HTTPS Listeners
- Listener Rules

**주요 변수**:

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `vpc_id` | VPC ID | - |
| `subnet_ids` | 서브넷 ID 목록 | - |
| `security_group_ids` | 보안 그룹 ID 목록 | - |
| `target_groups` | 타겟 그룹 설정 (map) | - |
| `certificate_arn` | HTTPS 인증서 ARN | `null` |

**출력값**: `alb_id`, `alb_arn`, `alb_dns_name`, `target_group_arns`

**사용 예제**:

```hcl
module "alb" {
  source = "github.com/terraform-aws-modules/modules/alb?ref=<Release Version>"

  environment        = "dev"
  project_name       = "myapp"
  service_name       = "web"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnet_ids
  security_group_ids = [module.security_group.security_group_ids["alb"]]

  target_groups = {
    app = {
      port              = 8080
      protocol          = "HTTP"
      target_type       = "instance"
      health_check_path = "/health"
    }
  }
}
```

---

### compute

EC2 인스턴스를 관리합니다.

**주요 리소스**:
- EC2 Instances
- Elastic IPs (선택 사항)

**주요 변수**:

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `instances` | 인스턴스 설정 (map) | - |
| `instances[].ami_id` | AMI ID | - |
| `instances[].instance_type` | 인스턴스 타입 | - |
| `instances[].subnet_id` | 서브넷 ID | - |
| `instances[].root_volume_size` | 루트 볼륨 크기 (GB) | `20` |
| `instances[].enable_eip` | Elastic IP 할당 | `false` |

**출력값**: `instance_ids`, `instance_private_ips`, `instance_public_ips`, `eip_public_ips`

**사용 예제**:

```hcl
module "compute" {
  source = "github.com/terraform-aws-modules/modules/compute?ref=<Release Version>"

  instances = {
    app-1 = {
      ami_id             = "ami-0c55b159cbfafe1f0"
      instance_type      = "t3.medium"
      subnet_id          = module.vpc.private_subnet_ids[0]
      security_group_ids = [module.security_group.security_group_ids["app"]]
      root_volume_size   = 30
    }
  }
}
```

---

### rds

Aurora 또는 RDS MySQL 데이터베이스를 구성합니다.

**주요 리소스**:
- Aurora RDS Cluster / RDS Instance
- DB Parameter Group
- IAM Role (Enhanced Monitoring)
- Secrets Manager Secret (선택 사항)

**주요 변수**:

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `engine_type` | 엔진 유형 (`aurora` 또는 `rds`) | `aurora` |
| `instance_class` | 인스턴스 클래스 | - |
| `instance_count` | Aurora 인스턴스 수 | `1` |
| `master_username` | 마스터 사용자명 | - |
| `master_password` | 마스터 비밀번호 | - |
| `db_subnet_group_name` | DB 서브넷 그룹 이름 | - |
| `backup_retention_period` | 백업 보관 기간 (일) | `7` |
| `enable_encryption` | 암호화 활성화 | `true` |

**출력값**: `id`, `endpoint`, `reader_endpoint`, `port`, `secret_arn`

**사용 예제**:

```hcl
module "rds" {
  source = "github.com/terraform-aws-modules/modules/rds?ref=<Release Version>"

  environment          = "dev"
  project_name         = "myapp"
  service_name         = "database"
  engine_type          = "aurora"
  instance_class       = "db.r6g.large"
  instance_count       = 2
  master_username      = "admin"
  master_password      = "your-secure-password"
  db_subnet_group_name = module.vpc.db_subnet_group_name
  security_group_ids   = [module.security_group.security_group_ids["db"]]
}
```

---

### s3

S3 버킷을 생성하고 보안 설정을 적용합니다.

**주요 리소스**:
- S3 Bucket
- Bucket Versioning
- Server-Side Encryption
- Public Access Block

**주요 변수**:

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `environment` | 환경 이름 | - |
| `project_name` | 프로젝트 이름 | - |
| `service_name` | 서비스 이름 | - |
| `enable_versioning` | 버전 관리 활성화 | `false` |
| `enable_encryption` | 암호화 활성화 | `true` |
| `force_destroy` | 강제 삭제 허용 | `false` |

**출력값**: `bucket_id`, `bucket_arn`, `bucket_domain_name`, `bucket_regional_domain_name`

**사용 예제**:

```hcl
module "s3" {
  source = "github.com/terraform-aws-modules/modules/s3?ref=<Release Version>"

  environment       = "dev"
  project_name      = "myapp"
  service_name      = "assets"
  enable_versioning = true
}
```

---

### cloudfront

CloudFront CDN 배포를 구성합니다. OAC(Origin Access Control)를 사용하여 S3 오리진을 보호합니다.

**주요 리소스**:
- CloudFront Distribution
- Origin Access Control
- S3 Bucket Policy

**주요 변수**:

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `s3_origin_domain_name` | S3 Regional Domain Name | - |
| `s3_bucket_id` | S3 버킷 ID | - |
| `s3_bucket_arn` | S3 버킷 ARN | - |
| `aliases` | 커스텀 도메인 목록 | `[]` |
| `acm_certificate_arn` | ACM 인증서 ARN | `null` |
| `default_ttl` | 기본 캐시 TTL (초) | `86400` |

**출력값**: `distribution_id`, `distribution_arn`, `distribution_domain_name`

**사용 예제**:

```hcl
module "cloudfront" {
  source = "github.com/terraform-aws-modules/modules/cloudfront?ref=<Release Version>"

  environment           = "dev"
  project_name          = "myapp"
  service_name          = "cdn"
  s3_origin_domain_name = module.s3.bucket_regional_domain_name
  s3_bucket_id          = module.s3.bucket_id
  s3_bucket_arn         = module.s3.bucket_arn
}
```

---

### iam

IAM 역할 및 정책을 관리합니다.

**주요 리소스**:
- IAM Role
- IAM Policy Attachments
- IAM Instance Profile (선택 사항)

**주요 변수**:

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `role_name` | 역할 이름 | - |
| `trusted_services` | 신뢰할 서비스 목록 | - |
| `managed_policy_arns` | AWS 관리형 정책 ARN 목록 | `[]` |
| `custom_policy` | 커스텀 정책 JSON | `null` |
| `create_instance_profile` | 인스턴스 프로파일 생성 | `false` |

**출력값**: `role_arn`, `role_name`, `instance_profile_arn`, `instance_profile_name`

**사용 예제**:

```hcl
module "iam_role" {
  source = "github.com/terraform-aws-modules/modules/iam?ref=<Release Version>"

  environment      = "dev"
  project_name     = "myapp"
  role_name        = "app-role"
  trusted_services = ["ec2.amazonaws.com"]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]

  create_instance_profile = true
}
```
