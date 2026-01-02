# Commit Generator

현재 변경사항을 분석하고, 이 프로젝트의 커밋 컨벤션에 맞는 커밋 메시지를 작성한 뒤 커밋까지 수행해주세요.

## 실행 순서

1. `git status`로 현재 상태 확인
2. `git log --oneline -10`으로 최근 커밋 히스토리를 확인하여 커밋 컨벤션 파악
3. `git diff --cached`로 스테이징된 변경사항 확인
4. 스테이징된 변경사항이 없으면 `git diff`로 unstaged 변경사항 확인 후 사용자에게 스테이징 여부 질문
5. 커밋 메시지 작성 후 사용자에게 프롬프트를 통해 승인 요청
6. 릴리즈 여부를 사용자에게 프롬프트로 질문
7. 릴리즈 요청 시, CHANGELOG.md 파일의 [Unreleased] 섹션에 변경사항 추가 (style, docs, chore, test 타입 제외)
8. `git commit` 실행 (릴리즈 시 CHANGELOG.md 변경사항 포함)
9. Push 및 Release 진행 여부를 프롬프트로 질문
10. 승인 시 `git push` 실행
11. 릴리즈 요청이 있었다면 `gh release create` 실행

## 커밋 메시지 작성 규칙

- 형식: `type: description`
- 언어: 한글 사용
- type 종류:
  - `init`: 초기 설정
  - `feat`: 새로운 기능 추가
  - `fix`: 버그 수정
  - `refactor`: 코드 리팩토링 (기능 변경 없음)
  - `docs`: 문서 수정
  - `style`: 코드 포맷팅, 세미콜론 누락 등
  - `test`: 테스트 코드 추가/수정
  - `chore`: 빌드, 패키지 매니저 설정 등

## 주의사항

- 커밋 실행 전 반드시 사용자에게 메시지 확인을 받을 것
- 변경사항이 여러 개인 경우 쉼표로 구분하여 하나의 메시지로 작성
- .env, credentials 등 민감한 파일이 포함되어 있으면 경고

## Push 및 Release 절차

Push와 Release를 한 번의 동작으로 수행합니다.

### 실행 조건

- 릴리즈 요청이 있는 경우: Push + Release 수행
- 릴리즈 요청이 없는 경우: Push만 수행

### Release 명령어

```bash
gh release create v<버전> --title "v<버전>" --notes-file CHANGELOG.md
```

### 버전 태그 규칙

1. `git tag --sort=-v:refname | head -1` 로 최신 태그 확인
2. 태그가 없으면 사용자에게 초기 버전 입력 요청 (예: v1.0.0)
3. 태그가 있으면 사용자에게 버전 증가 유형 질문:
   - MAJOR: X.0.0 (호환되지 않는 API 변경)
   - MINOR: 0.X.0 (기능 추가)
   - PATCH: 0.0.X (버그 수정)
4. 선택에 따라 자동으로 다음 버전 생성

## CHANGELOG 관리

릴리즈 요청 시 CHANGELOG.md 파일을 자동으로 업데이트합니다.

### CHANGELOG 자동 기록 규칙

- CHANGELOG.md가 없으면 아래 템플릿으로 새로 생성
- [Unreleased] 섹션의 해당 카테고리에 항목 추가
- style, docs, chore, test 타입은 CHANGELOG에 기록하지 않음

### CHANGELOG 형식 (Keep a Changelog)

- 파일 위치: 프로젝트 루트의 `CHANGELOG.md`
- 형식 예시:

  ```
  # Changelog

  ## [Unreleased]

  ## [1.0.0] - 2024-01-15
  ### Added
  - 새로운 기능 설명

  ### Changed
  - 변경된 기능 설명

  ### Fixed
  - 수정된 버그 설명

  ### Removed
  - 제거된 기능 설명
  ```

### 버전 규칙 (Semantic Versioning)

- **MAJOR** (X.0.0): 호환되지 않는 API 변경
- **MINOR** (0.X.0): 하위 호환성 유지하며 기능 추가
- **PATCH** (0.0.X): 하위 호환성 유지하며 버그 수정

### 커밋 타입 → CHANGELOG 카테고리 매핑

| 커밋 타입  | CHANGELOG 카테고리 |
|----------|-------------------|
| feat     | Added             |
| fix      | Fixed             |
| refactor | Changed           |
| style    | (제외)            |
| docs     | (제외)            |
| chore    | (제외)            |
| test     | (제외)            |
