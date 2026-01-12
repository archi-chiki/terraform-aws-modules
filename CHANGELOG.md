# Changelog

## [0.1.8](https://github.com/archi-chiki/terraform-aws-modules/compare/v0.1.7...v0.1.8) (2026-01-12)

### Code Refactoring

* **s3,vpc,security-group:** 하드코딩 값 변수화 및 태그 포맷팅 정리 ([c489a21](https://github.com/archi-chiki/terraform-aws-modules/commit/c489a2176f4059f9bb4492f670d52a983da1a7b0))

## [0.1.7](https://github.com/archi-chiki/terraform-aws-modules/compare/v0.1.6...v0.1.7) (2026-01-09)

### Code Refactoring

* **iam:** role_description 변수에서 default 값 제거 ([12a9274](https://github.com/archi-chiki/terraform-aws-modules/commit/12a92745f9f19e7f2f97ce3761622025696696bd))

## [0.1.6](https://github.com/archi-chiki/terraform-aws-modules/compare/v0.1.5...v0.1.6) (2026-01-07)

### Code Refactoring

* **vpc,security-group:** 중복 Environment 태그 제거 및 aws_region default 삭제 ([2f367f1](https://github.com/archi-chiki/terraform-aws-modules/commit/2f367f1e7747b00aaf1129acf1544949eae8010c))

## [0.1.5](https://github.com/archi-chiki/terraform-aws-modules/compare/v0.1.4...v0.1.5) (2026-01-05)

### Code Refactoring

* **compute:** 단일 인스턴스 모듈로 구조 변경 ([cf6d15a](https://github.com/archi-chiki/terraform-aws-modules/commit/cf6d15a5213b2688111f6348ea391ee79995a276))

## [0.1.4](https://github.com/archi-chiki/terraform-aws-modules/compare/v0.1.3...v0.1.4) (2026-01-02)

### Bug Fixes

* semantic-release changelogTitle 설정 추가 ([2c278b5](https://github.com/archi-chiki/terraform-aws-modules/commit/2c278b5b60416fe1f44dd6e8c6ee090bb8342d4b))

## [0.1.3](https://github.com/archi-chiki/terraform-aws-modules/compare/v0.1.2...v0.1.3) (2026-01-02)

### Code Refactoring

* **compute:** EC2 인스턴스 outputs을 개별 속성별로 분리 ([9ee7e54](https://github.com/archi-chiki/terraform-aws-modules/commit/9ee7e54db46780b9d125d10a159b1ad223334c16))

## [0.1.2](https://github.com/archi-chiki/terraform-aws-modules/compare/v0.1.1...v0.1.2) (2026-01-02)

### Code Refactoring

* 모듈 outputs 정리, RDS lifecycle ignore_changes 개선 ([f884d01](https://github.com/archi-chiki/terraform-aws-modules/commit/f884d01170906d85685019c4e39e9a8d9c2949df))

## [0.1.1](https://github.com/archi-chiki/terraform-aws-modules/compare/v0.1.0...v0.1.1) (2026-01-02)

### Features

* RDS 클러스터에 delete_automated_backups 옵션 추가

## [0.1.0](https://github.com/archi-chiki/terraform-aws-modules/releases/tag/v0.1.0) (2026-01-02)

### Features

* Terraform AWS 모듈 프로젝트 초기 구성
