# 강점찾기 기반 개인 프로필 완성 툴

## 설치

내 컴퓨터에 맞는 한 줄만 복사해서 붙여넣고 Enter를 누릅니다.

Windows:

```powershell
irm https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/install.ps1 | iex
```

Mac:

```bash
curl -fsSL https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/install.sh | bash
```

Windows는 PowerShell, Mac은 Terminal 앱에 붙여넣으면 됩니다. 이 한 줄은 Claude Code 설치 확인, 필요 시 설치, 강점찾기 플러그인 설치, 설치 목록 확인까지 진행합니다. 설치 중 JuriSupport MCP도 연결할지 묻습니다. 토큰이 있으면 `y`를 누르고 토큰만 붙여넣고, 아직 없으면 Enter를 눌러 건너뜁니다. Codex가 설치되어 있으면 같은 토큰으로 Codex MCP도 함께 등록합니다. 처음 설치했다면 설치 후 새 터미널에서 `claude`를 실행해 로그인합니다.

Codex에서 쓰려면 Claude Code 설치 스크립트 대신 아래 수동 설치 명령을 사용합니다.

## 문제가 있을 때 재설치

설치가 꼬였거나 플러그인이 보이지 않으면 아래 한 줄로 JuriSupport 관련 설정만 지우고 다시 설치합니다. Claude Code와 Codex 자체, 그리고 JuriSupport와 무관한 다른 플러그인은 지우지 않습니다.

Windows:

```powershell
irm https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/reinstall.ps1 | iex
```

Mac:

```bash
curl -fsSL https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/reinstall.sh | bash
```

JuriSupport 변호사 강점찾기 Claude Code 플러그인은 변호사가 자신의 업무 경험, 사건 자료, 상담 방향을 바탕으로 스스로 읽고 활용할 수 있는 개인 프로필을 완성하도록 돕습니다.

완성된 프로필은 자기소개 정리, 홈페이지·블로그 소개글 초안, 상담 분야 점검, 앞으로 받고 싶은 사건 방향 정리에 활용할 수 있습니다. JuriSupport에 올릴지와 무관하게 브라우저에서 바로 고쳐 쓸 수 있는 HTML 파일을 받고, 그 안에는 JuriSupport에 올릴 수 있는 가입·동의 링크 안내가 함께 들어갑니다. 기술적인 파일 형식이나 업로드 형식을 몰라도 됩니다. 핵심은 "내가 어떤 의뢰인 질문에 잘 답할 수 있는 변호사인지"를 분명하게 정리하는 것입니다.

변호사용 시작 흐름은 JuriSupport 가입이 아니라 이 강점찾기 플러그인에서 프로필을 완성하는 것부터입니다. 가입과 웹 동의는 완성한 프로필을 JuriSupport에 올리고 싶을 때만 이어지는 후속 단계입니다.

JuriSupport 사건목록, 진행내역, 할일/마감, 상담 신청 이력을 불러오거나 완성한 프로필을 JuriSupport에 올리는 실행은 JuriSupport MCP 연결이 필요합니다. 플러그인은 작업을 시작할 때 먼저 MCP 필요성을 안내해야 하며, MCP가 연결되어 있지 않으면 토큰 발급과 MCP 등록을 먼저 진행해야 합니다.

원하면 완성한 프로필을 JuriSupport에 올릴 수 있습니다. JuriSupport에 올린 프로필은 의뢰인이 상담 가능한 변호사 목록을 볼 때, 의뢰인의 질문과 변호사 프로필의 상담 분야·강점이 얼마나 가까운지에 따라 노출에 반영됩니다.

이 플러그인 자체가 프로필을 자동 공개하거나 의뢰인을 배정하지는 않습니다. 원본 사건기록은 자동으로 올라가지 않습니다. JuriSupport에 올리려면 프로필을 완성한 뒤 웹에서 가입·로그인하고 동의 절차를 마쳐야 하며, 공개와 노출은 별도 검토 절차를 따릅니다.

일부 워크플로우 설계 패턴은 오픈소스 프로젝트에서 변형해 사용했습니다. 자세한 표시는 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)를 확인하세요.

## 포함하지 않는 것

이 공개 배포용 패키지에는 JuriSupport의 비공개 문의 연결 로직, 내부 승인 정책, 상세 평가 루브릭, 검토자 도구, 운영 데이터 구조가 포함되어 있지 않습니다.

## 무엇을 도와주나요

- 본인의 사건자료에서 반복되는 업무 패턴과 강점을 정리합니다.
- 기존 JuriSupport 이용자는 사건목록, 진행상태, 할일/마감, 상담 신청 이력만으로도 반복 업무 패턴과 강점 후보를 정리할 수 있습니다.
- 앞으로 받고 싶은 의뢰인 질문과 사건 유형을 분명하게 만듭니다.
- 현재 프로필이나 홈페이지 소개문이 실제 강점과 맞는지 시장지향성, 자원기반관점, 서비스품질, 전문서비스펌 관리, SWOT 한계 연구를 바탕으로 점검합니다.
- 문화·예술·콘텐츠·스타트업·가사·노동 등 자신의 실제 업무 방향에 맞는 소개 문구를 다듬습니다.
- 과장되거나 공개하면 위험한 표현을 걸러냅니다.
- 업로드 여부와 무관하게 수정 가능한 개인 프로필 HTML 파일을 만들고, JuriSupport 가입·동의 안내를 함께 넣습니다.
- 원하면 JuriSupport에 올릴 수 있도록 프로필을 정리합니다.

## 수동 설치 시 사전 준비

- Git
- Claude Code 또는 Codex 설치 및 로그인 완료 상태
- JuriSupport 연동 실행 시 사용할 JuriSupport MCP 토큰

## 수동 설치

### Codex

Codex에 마켓플레이스를 한 번 등록한 뒤 플러그인을 설치합니다.

```bash
codex plugin marketplace add https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git
codex plugin add jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin
```

설치 후에는 새 Codex 스레드에서 바로 사용할 수 있습니다. Codex 앱에서는 Plugins 화면에서 `JuriSupport Lawyer Profile`을 찾아 설치해도 됩니다.

설치 상태는 터미널에서 확인할 수 있습니다.

```bash
codex plugin list
```

### Claude Code

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

## JuriSupport MCP 연결

처음 설치할 때 MCP 연결을 건너뛰었거나, 토큰을 새로 발급받았다면 아래 절차로 다시 연결합니다. JuriSupport 사건목록, 진행내역, 할일/마감, 상담 신청 이력을 참고하거나 프로필을 JuriSupport에 올릴 계획이면 플러그인 실행 전에 MCP를 연결합니다.

1. JuriSupport 웹에 로그인합니다.
2. 프로필 화면의 `MCP 연결` 섹션에서 토큰을 발급합니다.
3. 사용하는 도구에 맞는 MCP 연결 명령을 실행합니다.

Codex:

Mac/Linux:

```bash
read -rsp "JuriSupport MCP token: " JURISUPPORT_MCP_TOKEN; echo
export JURISUPPORT_MCP_TOKEN
codex mcp add jurisupport --url https://api.jurisupport.com/mcp --bearer-token-env-var JURISUPPORT_MCP_TOKEN
```

Windows PowerShell:

```powershell
$env:JURISUPPORT_MCP_TOKEN = Read-Host "JuriSupport MCP token"
codex mcp add jurisupport --url https://api.jurisupport.com/mcp --bearer-token-env-var JURISUPPORT_MCP_TOKEN
```

Codex는 MCP 토큰을 `JURISUPPORT_MCP_TOKEN` 환경변수에서 읽습니다. 위 연결 스크립트는 Mac/Linux에서는 `~/.jurisupport-mcp.env`, Windows에서는 사용자 환경변수에 값을 저장해 새 세션에서도 Codex가 읽을 수 있게 합니다.

Claude Code:

Windows:

```powershell
irm https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/connect-mcp.ps1 | iex
```

Mac:

```bash
curl -fsSL https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/connect-mcp.sh | bash
```

명령을 실행한 뒤 `JuriSupport MCP 토큰만 붙여넣고 Enter를 누르세요`라는 안내가 나오면 발급받은 토큰만 붙여넣습니다. 입력은 화면에 보이지 않는 것이 정상입니다. `Authorization`, `Bearer`, 따옴표, `<`, `>`는 입력하지 않습니다. 토큰을 채팅이나 다른 사람에게 보냈다면 그 토큰은 폐기하고 새로 발급받습니다.

이미 `jurisupport` MCP가 등록되어 있어도 위 명령이 Claude Code와 Codex의 기존 연결을 지우고 다시 등록합니다.

Mac에서 방금 연결한 같은 터미널 창에서 바로 Codex를 실행하려면 먼저 `source ~/.jurisupport-mcp.env`를 실행합니다. 새 터미널을 열면 자동으로 적용됩니다.

```bash
claude mcp get jurisupport
```

## 실행

설치가 끝나면 매번 플러그인 경로를 붙일 필요가 없습니다. 원하는 작업 폴더에서 Codex나 Claude Code를 평소처럼 실행합니다.

Codex:

```bash
codex
```

업무자료가 있는 폴더를 Codex가 함께 읽을 수 있게 하려면 `--add-dir`을 붙입니다.

```bash
codex --add-dir /path/to/case-records
```

Claude Code:

```bash
claude
```

업무자료가 있는 폴더를 Claude Code가 함께 읽을 수 있게 하려면 `--add-dir`을 붙입니다.

```bash
claude --add-dir /path/to/case-records
```

폴더 경로를 복사하는 방법:

- macOS Finder: 폴더를 선택한 뒤 `Command + Option + C`를 누르면 전체 경로가 복사됩니다.
- Windows 탐색기: 폴더를 연 뒤 주소창을 클릭하거나 `Alt + D`를 누르고, `Ctrl + C`로 복사합니다.
- 터미널: 해당 폴더로 이동한 뒤 `pwd`를 실행해 나온 경로를 복사합니다.
- Claude Code를 터미널에서 쓰는 중이면 폴더를 터미널 창으로 드래그해도 경로가 들어갈 수 있습니다.

예:

```text
/Users/name/Documents/case-records
```

자료 폴더가 여러 개이면 한 줄에 하나씩 붙여넣으면 됩니다.
여러 폴더를 제시하면 플러그인이 먼저 각 폴더의 자료 유형과 규모를 훑어 `자료 지도`와 `분석 계획`을 만든 뒤, 어떤 자료부터 강점 추출에 사용할지 제안합니다.
자료가 많을 때는 사건 목록이나 경유증표로 많이 수행한 사건유형과 시기별 분포를 먼저 파악합니다. 진행중/확정된 사건 폴더를 검토할 때는 그 안의 판결문, 조정조서나 조정결정문, 화해권고결정문, 결정문처럼 절차나 결론을 추단할 수 있는 자료를 사건별 판단근거로 봅니다.
작성서류만 있는 경우, 사건기록만 있는 경우, 둘 다 있는 경우, 판결문·조정결정문·화해권고결정문 같은 결론 자료만 있는 경우를 구분해 강점 후보의 신뢰도와 공개 가능성을 다르게 판단합니다.

Claude Code 안에서 다음 스킬을 사용합니다.

```text
/jurisupport-lawyer-profile:complete-personal-profile
/jurisupport-lawyer-profile:profile-strategy-audit
/jurisupport-lawyer-profile:upload-to-jurisupport
```

Codex에서는 새 스레드에서 작업을 자연어로 요청하거나 `/skills` 또는 `@` picker에서 같은 스킬을 선택합니다.

## 직접 내려받아 확인하고 싶을 때

레포 내용을 먼저 보고 검증하려면 원하는 위치에 내려받을 수 있습니다.

```bash
mkdir -p ~/claude-plugins
git clone https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git \
  ~/claude-plugins/jurisupport-lawyer-profile-plugin
cd ~/claude-plugins/jurisupport-lawyer-profile-plugin
claude plugin validate .
codex plugin marketplace add .
codex plugin add jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin
```

## 기본 사용 흐름

1. `/jurisupport-lawyer-profile:complete-personal-profile`을 실행합니다.
2. 플러그인이 먼저 JuriSupport MCP 연결 여부를 묻고, 사건목록·진행내역·할일까지 참고할지 로컬 자료만으로 진행할지 확인합니다.
3. 참고할 사건자료, 작성서류, 판결문, 조정조서나 조정결정문, 화해권고결정문, 홈페이지 소개글, 또는 직접 정리한 내용을 알려줍니다. 폴더가 있으면 위 방식으로 전체 경로를 복사해 붙여넣습니다.
4. 폴더가 여러 개이면 Claude Code가 먼저 `자료 지도`와 `분석 계획`을 제시하고, 제외해야 할 사건이나 특히 민감한 폴더가 있는지만 확인합니다.
5. 자료가 많으면 사건 목록이나 경유증표로 많이 수행한 분야를 먼저 파악하고, 진행중/확정된 사건 폴더 안의 판결문, 조정조서나 조정결정문, 화해권고결정문, 결정문 등으로 사건유형·쟁점·절차·결과 맥락을 잡습니다. 이어서 작성서류로 변호사의 실제 업무방식과 역할을 확인합니다. 작성서류만 있는 경우에는 문서작성·쟁점정리 패턴을 중심으로 보고, 사건기록만 있는 경우에는 사건유형·절차·반복 패턴을 보되 변호사의 직접 역할이 확인되는지 따로 점검합니다.
6. Claude Code가 "앞으로 어떤 질문을 한 의뢰인을 만나고 싶은지"부터 짧게 묻습니다.
7. 자료에서 확인되는 업무 패턴과 원하는 상담 방향을 대조합니다. JuriSupport 기존 이용자는 사건목록의 반복 분야, 진행상태, 할일/마감, 상담 신청 이력에서 드러나는 접수·자료요청·후속안내·마감관리 패턴도 강점 후보로 봅니다.
8. 현재 프로필이 있으면 실제 강점과 비교해 약점, 기회, 위험, 마케팅 메시지, 상담 운영 적합성을 점검합니다.
9. 프로필 문구 후보별 근거, 공개 가능성, 과장 위험, 원하는 상담 유형과의 적합성을 정리합니다.
10. 변호사가 직접 읽고 수정할 수 있는 개인 프로필을 완성합니다.
11. 업로드 여부와 무관하게 `jurisupport-personal-profile.html` 같은 수정 가능한 개인 프로필 HTML 파일을 만듭니다. 이 파일에는 원할 때 JuriSupport 프로필 검토 절차를 시작할 수 있는 가입·동의 링크 안내를 넣습니다.
12. 그 프로필은 사무소 소개, 자기소개, 상담 분야 정리, 향후 마케팅 문구 점검에 활용할 수 있습니다.
13. JuriSupport에 올리고 싶을 때만 웹에서 가입·로그인 후 동의 페이지를 완료합니다.
14. 이후 `/jurisupport-lawyer-profile:upload-to-jurisupport`로 완성한 프로필을 JuriSupport에 올릴 수 있습니다.
15. JuriSupport에 올린 프로필은 의뢰인의 질문과 유사도가 맞을 때 상담 가능한 변호사 목록에 노출될 수 있습니다.

프로필을 먼저 완성한 뒤 JuriSupport에 올리고 싶을 때는 다음 URL에서 가입과 웹 동의를 진행합니다.

```text
https://jurisupport.com/signup?redirect=/lawyer-search/profile/consent
```

웹 동의가 없으면 JuriSupport에 프로필을 올릴 수 없습니다. 다만 이 단계는 시작점이 아니라, 완성한 프로필을 올리기 위한 확인 절차입니다. 프로필을 올리는 것과 공개 승인·노출 시작은 별도 단계입니다.

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
codex plugin marketplace upgrade jurisupport-lawyer-profile-plugin
codex plugin remove jurisupport-lawyer-profile
codex plugin add jurisupport-lawyer-profile@jurisupport-lawyer-profile-plugin

claude plugin marketplace update jurisupport-lawyer-profile-plugin
claude plugin update jurisupport-lawyer-profile
```

## 업로드 데이터 참고

JuriSupport에 올릴 프로필 데이터를 점검할 때는 `examples/minimal-profile-draft.json`을 최소 정답 예시로 먼저 보고, `schemas/lawyer-profile-draft.public.schema.json`으로 세부 필드와 enum을 확인합니다. 상담 방식은 `phone`, `online`, `office`, `text`, `kakaotalk`, `messenger`, `other` 코드만 사용합니다.

## 데이터 처리 원칙

- 변호사가 선택한 파일이나 폴더만 검토합니다.
- 원본 사건기록 파일은 자동 업로드하지 않습니다.
- 로컬 HTML 파일은 업로드 여부와 무관하게 만들며, 이 파일 자체가 공개나 업로드를 뜻하지 않습니다.
- 공개 프로필 필드에는 사건번호, 당사자명, 주소, 고유 사실관계, 사적 대화, 내부 전략을 넣지 않습니다.
- SWOT, 마케팅, 조직 운영 진단과 연구 기반 판단 근거는 변호사용 내부 판단 자료이며 고객에게 그대로 공개하지 않습니다.
- JuriSupport에는 변호사가 확인한 프로필 내용만 선택적으로 올립니다.
- 프로필을 올리는 것만으로 공개나 노출이 바로 시작되는 것은 아닙니다.
