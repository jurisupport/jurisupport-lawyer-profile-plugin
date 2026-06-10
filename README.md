# 내 개인 프로필 완성 툴

JuriSupport 변호사 프로필 Claude Code 플러그인은 변호사가 자신의 업무 자료를 바탕으로 본인의 개인 프로필을 완성할 수 있게 돕습니다. 원하면 완성한 프로필을 JuriSupport에 올릴 draft까지 만들 수 있습니다.

먼저 로컬 Claude Code 환경에서 `jurisupport-personal-profile.md`를 만듭니다. "어떤 질문을 한 의뢰인을 만나고 싶은지", "어떤 사건을 더 받고 싶은지"를 정리하고, 실제 자료에서 확인되는 업무 패턴을 바탕으로 공개 가능한 프로필 문구를 준비하는 흐름입니다.

프로필을 완성한 뒤 JuriSupport에 올리면, 등록된 상담 분야와 강점에 가까운 질문을 남긴 의뢰인 문의를 더 잘 확인할 수 있습니다. JuriSupport에 올릴 수 있는 프로필 draft JSON은 변호사가 원할 때만 추가로 만듭니다.

이 플러그인 자체는 프로필을 공개하거나 의뢰인을 배정하지 않습니다. 변호사를 추천, 알선, 순위화, 광고, 스폰서 노출하지도 않습니다. 원본 사건기록 파일을 자동 업로드하지 않고, 변호사가 확인한 draft JSON만 선택적으로 올립니다. JuriSupport 업로드 없이 내 개인 프로필 파일만 만들 수도 있습니다.

## 포함하지 않는 것

이 공개 배포용 패키지에는 JuriSupport의 비공개 문의 연결 로직, 내부 승인 정책, 상세 평가 루브릭, 검토자 도구, 운영 데이터 구조가 포함되어 있지 않습니다.

## 무엇을 도와주나요

- 본인의 사건자료에서 반복되는 업무 패턴과 강점을 정리합니다.
- `jurisupport-personal-profile.md`로 내 개인 프로필을 완성합니다.
- 원하면 JuriSupport에 올릴 `jurisupport-profile-draft.json`을 만듭니다.
- JuriSupport에 올린 프로필이 유사한 의뢰인 질문을 확인하는 데 쓰일 수 있도록 상담 분야와 공개 문구를 정돈합니다.

## 사전 준비

- Git
- Claude Code 로그인 완료 상태

## 설치

Claude Code에 마켓플레이스를 한 번 등록한 뒤 플러그인을 설치합니다.

```bash
claude plugin marketplace add https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git
claude plugin install jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin
```

설치가 끝나면 새 Claude Code 세션부터 자동으로 사용할 수 있습니다. 이미 열린 세션에서는 Claude Code 안에서 다음 명령을 실행합니다.

```text
/reload-plugins
```

설치 상태는 터미널에서 확인할 수 있습니다.

```bash
claude plugin list
```

## 실행

설치가 끝나면 매번 `--plugin-dir`를 붙일 필요가 없습니다. 원하는 작업 폴더에서 Claude Code를 평소처럼 실행합니다.

```bash
claude
```

사건자료 폴더를 Claude Code가 함께 읽을 수 있게 하려면 `--add-dir`을 붙입니다.

```bash
claude --add-dir /path/to/case-records
```

Claude Code 안에서 다음 스킬을 사용합니다.

```text
/jurisupport-lawyer-profile:complete-personal-profile
/jurisupport-lawyer-profile:upload-to-jurisupport
```

## 직접 내려받아 확인하고 싶을 때

레포 내용을 먼저 보고 검증하려면 원하는 위치에 내려받을 수 있습니다.

```bash
mkdir -p ~/claude-plugins
git clone https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git \
  ~/claude-plugins/jurisupport-lawyer-profile-plugin
cd ~/claude-plugins/jurisupport-lawyer-profile-plugin
claude plugin validate .
```

## 기본 사용 흐름

1. `/jurisupport-lawyer-profile:complete-personal-profile`을 실행합니다.
2. 사건 폴더, 판결문 파일, 작성서류 폴더, 또는 직접 요약한 내용을 알려줍니다.
3. Claude Code가 짧은 프로필 점검 인터뷰로 "앞으로 어떤 질문을 한 의뢰인을 만나고 싶은지"부터 묻고, 자료에서 확인되는 업무 패턴과 대조합니다.
4. 프로필 문구 후보별 근거, 공개 가능성, 과장 위험, 원하는 상담 유형과의 적합성을 정리합니다.
5. 먼저 `jurisupport-personal-profile.md`를 만듭니다.
6. 변호사가 원하면 `jurisupport-profile-draft.json`과 `jurisupport-profile-review.md`를 추가로 만듭니다.
7. JuriSupport MCP가 연결되어 있고 변호사가 원하면 `/jurisupport-lawyer-profile:upload-to-jurisupport`로 draft를 올립니다.
8. JuriSupport에 올린 프로필은 유사한 질문을 한 의뢰인 상담 요청을 확인하는 데 활용될 수 있습니다.

MCP 업로드는 draft 업로드만 합니다. 공개 승인이나 검색 노출은 별도 검토 절차를 거쳐야 합니다.

## 매번 짧게 실행하고 싶을 때

설치 후에는 alias에 플러그인 경로를 넣을 필요가 없습니다. 사건자료 폴더를 자주 함께 여는 경우에만 셸 설정 파일에 alias를 추가할 수 있습니다.

```bash
alias jurisupport-profile='claude --add-dir /path/to/case-records'
```

이후에는 원하는 작업 폴더에서 다음처럼 실행합니다.

```bash
jurisupport-profile
```

## 업데이트

새 버전을 받으려면:

```bash
claude plugin marketplace update jurisupport-lawyer-profile-plugin
claude plugin update jurisupport-lawyer-profile
```

## 데이터 처리 원칙

- 변호사가 선택한 파일이나 폴더만 검토합니다.
- 원본 사건기록 파일은 자동 업로드하지 않습니다.
- 공개 프로필 필드에는 사건번호, 당사자명, 주소, 고유 사실관계, 사적 대화, 내부 전략을 넣지 않습니다.
- JuriSupport MCP로 보내는 것은 변호사가 확인한 draft JSON입니다.
- draft 업로드는 프로필 공개가 아닙니다.

## 산출물

항상 만드는 산출물:

- `jurisupport-personal-profile.md`

선택적으로 만드는 산출물:

- `jurisupport-profile-draft.json`
- `jurisupport-profile-review.md`
- `jurisupport-profile-upload-package.json`

스키마:

- `schemas/lawyer-profile-draft.public.schema.json`

예시:

- `examples/minimal-profile-draft.json`
