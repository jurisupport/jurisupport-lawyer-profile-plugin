# JuriSupport 변호사 프로필 Claude Code 플러그인

JuriSupport 변호사 프로필 등록 초안을 만들기 위한 Claude Code 플러그인입니다.

변호사가 자신의 로컬 Claude Code 환경에서 전자소송 기록, 판결문, 작성서류, 사건 진행 메모 등을 선택해 검토하고, JuriSupport에 제출할 수 있는 프로필 draft JSON을 만드는 용도입니다.

이 플러그인은 프로필을 공개하지 않습니다. 변호사를 추천, 알선, 순위화, 광고, 스폰서 노출하지도 않습니다. 원본 사건기록 파일을 자동 업로드하지 않고, 변호사가 확인한 draft JSON만 선택적으로 제출합니다.

## 포함하지 않는 것

이 공개 배포용 패키지에는 JuriSupport의 비공개 매칭 로직, 내부 승인 정책, 상세 평가 루브릭, 검토자 도구, 운영 데이터 구조가 포함되어 있지 않습니다.

## 사전 준비

- GitHub private repo 접근 권한
- Git 또는 GitHub CLI
- Claude Code 로그인 완료 상태

권한 문제로 clone이 실패하면 먼저 GitHub CLI에 로그인합니다.

```bash
gh auth login
```

## 설치

원하는 위치에 플러그인을 내려받습니다.

```bash
mkdir -p ~/claude-plugins
git clone https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git \
  ~/claude-plugins/jurisupport-lawyer-profile-plugin
cd ~/claude-plugins/jurisupport-lawyer-profile-plugin
```

플러그인 형식을 확인합니다.

```bash
claude plugin validate .
```

## 실행

플러그인 폴더에서 바로 실행하려면:

```bash
claude --plugin-dir .
```

다른 작업 폴더에서 실행하려면 플러그인 경로를 지정합니다.

```bash
claude --plugin-dir ~/claude-plugins/jurisupport-lawyer-profile-plugin
```

사건자료 폴더를 Claude Code가 함께 읽을 수 있게 하려면 `--add-dir`을 붙입니다.

```bash
claude \
  --plugin-dir ~/claude-plugins/jurisupport-lawyer-profile-plugin \
  --add-dir /path/to/case-records
```

Claude Code 안에서 다음 스킬을 사용합니다.

```text
/jurisupport-lawyer-profile:profile-draft-from-records
/jurisupport-lawyer-profile:upload-via-mcp
```

## 기본 사용 흐름

1. `/jurisupport-lawyer-profile:profile-draft-from-records`를 실행합니다.
2. 사건 폴더, 판결문 파일, 작성서류 폴더, 또는 직접 요약한 내용을 알려줍니다.
3. Claude Code가 자료에서 확인되는 업무 패턴을 정리합니다.
4. 변호사가 앞으로 받고 싶은 상담 유형과 제외할 사건 유형을 확인합니다.
5. `jurisupport-profile-draft.json`과 `jurisupport-profile-review.md`를 만듭니다.
6. JuriSupport MCP가 연결되어 있고 변호사가 원하면 `/jurisupport-lawyer-profile:upload-via-mcp`로 draft를 제출합니다.

MCP 업로드는 draft 제출만 합니다. 공개 승인이나 검색 노출은 별도 검토 절차를 거쳐야 합니다.

## 매번 짧게 실행하고 싶을 때

셸 설정 파일에 alias를 추가할 수 있습니다.

```bash
alias jurisupport-profile='claude --plugin-dir ~/claude-plugins/jurisupport-lawyer-profile-plugin'
```

이후에는 원하는 작업 폴더에서 다음처럼 실행합니다.

```bash
jurisupport-profile --add-dir /path/to/case-records
```

## 업데이트

새 버전을 받으려면:

```bash
cd ~/claude-plugins/jurisupport-lawyer-profile-plugin
git pull
claude plugin validate .
```

## 데이터 처리 원칙

- 변호사가 선택한 파일이나 폴더만 검토합니다.
- 원본 사건기록 파일은 자동 업로드하지 않습니다.
- 공개 프로필 필드에는 사건번호, 당사자명, 주소, 고유 사실관계, 사적 대화, 내부 전략을 넣지 않습니다.
- JuriSupport MCP로 보내는 것은 draft JSON입니다.
- draft 제출은 프로필 공개가 아닙니다.

## 산출물

기본 산출물:

- `jurisupport-profile-draft.json`
- `jurisupport-profile-review.md`
- `jurisupport-profile-upload-package.json`

스키마:

- `schemas/lawyer-profile-draft.public.schema.json`

예시:

- `examples/minimal-profile-draft.json`

## 로컬 개발 경로

JuriSupport 비공개 기획 workspace에서 테스트하는 경우:

```bash
claude --plugin-dir /Users/haheebong/Documents/jurisupport-lawyer-search-private/public-release/claude-code-plugins/jurisupport-lawyer-profile
```
