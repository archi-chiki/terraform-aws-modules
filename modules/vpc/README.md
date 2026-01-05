# SmileShark AWS VPC Terraform Module

AWS VPC 네트워크 인프라를 생성하는 Terraform 모듈입니다.

## 생성되는 리소스

- VPC (DNS 호스트이름 및 DNS 지원 활성화)
- Internet Gateway
- Public Subnets (멀티 AZ)
- Private Subnets (멀티 AZ)
- DB Subnets (멀티 AZ)
- NAT Gateway (선택적, 단일 또는 AZ별)
- Elastic IP (NAT Gateway용)
- Route Tables (Public, Private, DB)
- Route Table Associations
- DB Subnet Group

## 사용 예시

```hcl
module "vpc" {
  source = "./modules/vpc"

  environment  = "dev"
  project_name = "my-project"
  service_name = "my-service"

  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  db_subnet_cidrs      = ["10.0.21.0/24", "10.0.22.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true  # 비용 최적화 (고가용성 필요시 false)
}
```

## Inputs

| 변수명 | 타입 | 필수 | 기본값 | 설명 |
|--------|------|:----:|--------|------|
| vpc_cidr | string | O | - | VPC CIDR 블록 |
| public_subnet_cidrs | list(string) | O | - | Public 서브넷 CIDR 목록 |
| private_subnet_cidrs | list(string) | O | - | Private 서브넷 CIDR 목록 |
| db_subnet_cidrs | list(string) | O | - | DB 서브넷 CIDR 목록 |
| availability_zones | list(string) | O | - | 사용할 AZ 목록 |
| environment | string | O | - | 환경명 (dev, staging, prod) |
| project_name | string | O | - | 프로젝트명 |
| service_name | string | O | - | 서비스명 (DB Subnet Group 네이밍용) |
| aws_region | string | - | us-west-2 | AWS 리전 |
| enable_nat_gateway | bool | - | false | NAT Gateway 활성화 여부 |
| single_nat_gateway | bool | - | true | 단일 NAT Gateway 사용 여부 |

## Outputs

| 출력값 | 설명 |
|--------|------|
| vpc_id | VPC ID |
| vpc_cidr_block | VPC CIDR 블록 |
| public_subnet_ids | Public 서브넷 ID 목록 |
| private_subnet_ids | Private 서브넷 ID 목록 |
| db_subnet_ids | DB 서브넷 ID 목록 |
| public_subnet_cidrs | Public 서브넷 CIDR 목록 |
| private_subnet_cidrs | Private 서브넷 CIDR 목록 |
| internet_gateway_id | Internet Gateway ID |
| nat_gateway_ids | NAT Gateway ID 목록 |
| nat_gateway_public_ips | NAT Gateway Elastic IP 목록 |
| public_route_table_ids | Public Route Table ID 목록 |
| private_route_table_ids | Private Route Table ID 목록 |
| db_route_table_ids | DB Route Table ID 목록 |
| db_subnet_group_name | DB Subnet Group 이름 |
| db_subnet_group_id | DB Subnet Group ID |
| availability_zones | 사용된 AZ 목록 |

## 요구사항

| 항목 | 버전 |
|------|------|
| Terraform | >= 1.13.0 |
| AWS Provider | >= 5.100.0 |

## 릴리스 규칙

이 모듈은 [semantic-release](https://github.com/semantic-release/semantic-release)를 사용하여 자동 릴리스됩니다.

### .releaserc.json 설정

저장소 분리 시 아래 설정 파일을 루트에 추가합니다:

```json
{
  "branches": ["main"],
  "plugins": [
    ["@semantic-release/commit-analyzer", {
      "preset": "conventionalcommits",
      "releaseRules": [
        { "type": "feat", "release": "minor" },
        { "type": "fix", "release": "patch" },
        { "type": "perf", "release": "patch" },
        { "type": "refactor", "release": "patch" },
        { "breaking": true, "release": "major" }
      ]
    }],
    ["@semantic-release/release-notes-generator", {
      "preset": "conventionalcommits"
    }],
    ["@semantic-release/changelog", {
      "changelogFile": "CHANGELOG.md",
      "changelogTitle": "# Changelog"
    }],
    ["@semantic-release/git", {
      "assets": ["CHANGELOG.md"],
      "message": "chore(release): ${nextRelease.version} [skip ci]"
    }],
    "@semantic-release/github"
  ]
}
```

### Conventional Commits 규칙

| 타입 | 설명 | 버전 영향 |
|------|------|----------|
| feat | 새로운 기능 추가 | MINOR |
| fix | 버그 수정 | PATCH |
| perf | 성능 개선 | PATCH |
| refactor | 코드 리팩토링 | PATCH |
| docs | 문서 수정 | - |
| chore | 빌드, 설정 변경 | - |
| BREAKING CHANGE | 호환되지 않는 변경 | MAJOR |

### 커밋 메시지 예시

```bash
# MINOR 버전 증가
feat(vpc): NAT Gateway 고가용성 옵션 추가

# PATCH 버전 증가
fix(vpc): 서브넷 CIDR 계산 오류 수정
refactor(vpc): Route Table 리소스 구조 개선

# MAJOR 버전 증가
feat(vpc)!: VPC CIDR 변수 구조 변경

BREAKING CHANGE: vpc_cidr 변수가 object 타입으로 변경됨
```

### CHANGELOG.md 형식

릴리스 시 자동 생성되는 형식:

```markdown
# Changelog

## [0.2.0](https://github.com/owner/repo/compare/v0.1.0...v0.2.0) (2026-01-05)

### Features

* **vpc:** NAT Gateway 고가용성 옵션 추가 (abc1234)

### Bug Fixes

* **vpc:** 서브넷 CIDR 계산 오류 수정 (def5678)
```
