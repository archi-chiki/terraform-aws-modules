# Commit Generator

현재 변경사항을 분석하고, Conventional Commits 형식에 맞는 커밋 메시지를 작성한 뒤 커밋까지 수행해주세요.

## 실행 순서

1. `git status`로 현재 상태 확인
2. `git log --oneline -10`으로 최근 커밋 히스토리를 확인하여 커밋 컨벤션 파악
3. `git diff --cached`로 스테이징된 변경사항 확인
4. 스테이징된 변경사항이 없으면 `git diff`로 unstaged 변경사항 확인 후 사용자에게 스테이징 여부 질문
5. 커밋 메시지 작성 후 사용자에게 프롬프트를 통해 승인 요청
6. 승인 시 `git commit` 실행
7. Push 여부를 프롬프트로 질문
8. 승인 시 `git push` 실행

## 커밋 메시지 작성 규칙 (Conventional Commits)

### 기본 형식

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### type 종류

| type     | 설명                          | 릴리즈 영향 |
|----------|------------------------------|------------|
| feat     | 새로운 기능 추가               | MINOR      |
| fix      | 버그 수정                      | PATCH      |
| perf     | 성능 개선                      | PATCH      |
| refactor | 코드 리팩토링 (기능 변경 없음)  | PATCH      |
| docs     | 문서 수정                      | -          |
| style    | 코드 포맷팅, 세미콜론 누락 등   | -          |
| test     | 테스트 코드 추가/수정           | -          |
| chore    | 빌드, 패키지 매니저 설정 등     | -          |
| revert   | 이전 커밋 되돌리기              | -          |

### Breaking Changes

호환되지 않는 변경사항이 있을 경우:

```
feat!: 호환되지 않는 API 변경

BREAKING CHANGE: 기존 API가 변경되었습니다.
```

또는 footer에 `BREAKING CHANGE:` 추가

### 예시

```
feat(rds): Aurora 클러스터에 delete_automated_backups 옵션 추가

fix(vpc): 서브넷 CIDR 계산 오류 수정

refactor(iam): 역할 정책 구조 개선
```

## 주의사항

- 커밋 실행 전 반드시 사용자에게 메시지 확인을 받을 것
- scope는 모듈명 사용 권장 (예: rds, vpc, iam)
- description은 한글 사용 가능
- .env, credentials 등 민감한 파일이 포함되어 있으면 경고

## 자동 릴리즈 안내

이 프로젝트는 **semantic-release**를 사용하여 릴리즈가 자동화되어 있습니다.

- main 브랜치에 push하면 자동으로 릴리즈 생성
- 커밋 메시지 기반으로 버전 자동 결정:
  - `feat`: MINOR 버전 증가 (0.X.0)
  - `fix`, `perf`, `refactor`: PATCH 버전 증가 (0.0.X)
  - `BREAKING CHANGE`: MAJOR 버전 증가 (X.0.0)
- CHANGELOG.md 자동 업데이트
- GitHub Release 자동 생성
