# 강점찾기 기반 개인 프로필 완성 툴

JuriSupport 변호사 강점찾기 Claude Code 플러그인은 변호사가 자신의 업무 경험, 사건 자료, 상담 방향을 바탕으로 스스로 읽고 활용할 수 있는 개인 프로필을 완성하도록 돕습니다.

완성된 프로필은 자기소개 정리, 홈페이지·블로그 소개글 초안, 상담 분야 점검, 앞으로 받고 싶은 사건 방향 정리에 활용할 수 있습니다. 기술적인 파일 형식이나 업로드 형식을 몰라도 됩니다. 핵심은 "내가 어떤 의뢰인 질문에 잘 답할 수 있는 변호사인지"를 분명하게 정리하는 것입니다.

변호사용 시작 흐름은 JuriSupport 가입이 아니라 이 강점찾기 플러그인에서 프로필을 완성하는 것부터입니다. 가입과 웹 동의는 완성한 프로필을 JuriSupport에 올리고 싶을 때만 이어지는 후속 단계입니다.

원하면 완성한 프로필을 JuriSupport에 올릴 수 있습니다. JuriSupport에 올린 프로필은 의뢰인이 상담 가능한 변호사 목록을 볼 때, 의뢰인의 질문과 변호사 프로필의 상담 분야·강점이 얼마나 가까운지에 따라 노출에 반영됩니다.

이 플러그인 자체가 프로필을 자동 공개하거나 의뢰인을 배정하지는 않습니다. 원본 사건기록은 자동으로 올라가지 않습니다. JuriSupport에 올리려면 프로필을 완성한 뒤 웹에서 가입·로그인하고 동의 절차를 마쳐야 하며, 공개와 노출은 별도 검토 절차를 따릅니다.

## 포함하지 않는 것

이 공개 배포용 패키지에는 JuriSupport의 비공개 문의 연결 로직, 내부 승인 정책, 상세 평가 루브릭, 검토자 도구, 운영 데이터 구조가 포함되어 있지 않습니다.

## 무엇을 도와주나요

- 본인의 사건자료에서 반복되는 업무 패턴과 강점을 정리합니다.
- 앞으로 받고 싶은 의뢰인 질문과 사건 유형을 분명하게 만듭니다.
- 문화·예술·콘텐츠·스타트업·가사·노동 등 자신의 실제 업무 방향에 맞는 소개 문구를 다듬습니다.
- 과장되거나 공개하면 위험한 표현을 걸러냅니다.
- 원하면 JuriSupport에 올릴 수 있도록 프로필을 정리합니다.

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

업무자료가 있는 폴더를 Claude Code가 함께 읽을 수 있게 하려면 `--add-dir`을 붙입니다.

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
2. 참고할 사건자료, 작성서류, 판결문, 홈페이지 소개글, 또는 직접 정리한 내용을 알려줍니다.
3. Claude Code가 "앞으로 어떤 질문을 한 의뢰인을 만나고 싶은지"부터 짧게 묻습니다.
4. 자료에서 확인되는 업무 패턴과 원하는 상담 방향을 대조합니다.
5. 프로필 문구 후보별 근거, 공개 가능성, 과장 위험, 원하는 상담 유형과의 적합성을 정리합니다.
6. 변호사가 직접 읽고 수정할 수 있는 개인 프로필을 완성합니다.
7. 그 프로필은 사무소 소개, 자기소개, 상담 분야 정리, 향후 마케팅 문구 점검에 활용할 수 있습니다.
8. JuriSupport에 올리고 싶을 때만 웹에서 가입·로그인 후 동의 페이지를 완료합니다.
9. 이후 `/jurisupport-lawyer-profile:upload-to-jurisupport`로 완성한 프로필을 JuriSupport에 올릴 수 있습니다.
10. JuriSupport에 올린 프로필은 의뢰인의 질문과 유사도가 맞을 때 상담 가능한 변호사 목록에 노출될 수 있습니다.

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
claude plugin marketplace update jurisupport-lawyer-profile-plugin
claude plugin update jurisupport-lawyer-profile
```

## 데이터 처리 원칙

- 변호사가 선택한 파일이나 폴더만 검토합니다.
- 원본 사건기록 파일은 자동 업로드하지 않습니다.
- 공개 프로필 필드에는 사건번호, 당사자명, 주소, 고유 사실관계, 사적 대화, 내부 전략을 넣지 않습니다.
- JuriSupport에는 변호사가 확인한 프로필 내용만 선택적으로 올립니다.
- 프로필을 올리는 것만으로 공개나 노출이 바로 시작되는 것은 아닙니다.
