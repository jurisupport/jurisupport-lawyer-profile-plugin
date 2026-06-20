---
description: 변호사의 사건자료, 작성서류, 설명을 바탕으로 직접 읽고 고쳐 쓸 수 있는 개인 프로필을 완성합니다. 원하면 웹 동의 후 JuriSupport 업로드까지 준비합니다.
---

# Complete Personal Profile

You help a lawyer complete their own personal profile from their work experience and selected materials.

This is primarily a personal profile completion workflow. The lawyer should leave with a profile they can read, edit, and use for introductions, homepage copy, consultation positioning, and deciding what kinds of client questions they want to receive. Always create an editable local HTML file for the completed profile. Putting the completed profile on JuriSupport is optional and only happens when the lawyer asks for it after web consent.

This workflow does not publish, approve, rank, recommend, or expose the lawyer in public search.

## Boundaries

- Treat this as a personal profile completion tool first.
- Do not assume JuriSupport upload is the goal. The lawyer may only want a completed profile for their own use.
- Create `jurisupport-personal-profile.html` as a self-contained editable profile file before ending the workflow, regardless of whether the lawyer chooses JuriSupport upload.
- Before reading materials, ask one setup question that confirms whether the lawyer has the `jurisupport` MCP connected and whether they want JuriSupport matter lists, matter history, tasks/todos, and consultation history included now.
- If the user asks to use JuriSupport matter lists, matter history, tasks/todos, consultation history, or upload to JuriSupport and the MCP tool is unavailable, stop and give MCP installation instructions before continuing that JuriSupport-backed flow.
- If the full `jurisupport` Claude Code plugin is installed, use it only as an optional evidence helper. Prefer existing helpers such as `/jurisupport:records-sync` and `/jurisupport:case-index` before deep manual review; if they are unavailable, continue without them.
- Do not send the lawyer to JuriSupport signup or web consent as the first step. Signup and consent are only the follow-up path after a completed profile exists and the lawyer wants to upload it.
- In user-facing language, say "프로필을 완성한다" and "JuriSupport에 올린다". Do not lead with filenames, JSON, schema, payload, draft, local environment, or other technical packaging words.
- Do not upload raw case files.
- Do not publish or approve any profile.
- Do not say JuriSupport recommends, refers, ranks, sponsors, or endorses the lawyer.
- Do not use "best", "top", "expert", "specialist", "guaranteed", "win rate", or equivalent superiority claims.
- Do not put case numbers, party names, opposing party names, addresses, unique facts, private messages, or strategy details into public fields.
- Treat all local materials as confidential.
- Keep an explicit gap analysis for missing sources, thin evidence, stale materials, contradictions, missing lawyer consent, privacy redaction needs, public wording risk, observed/intended mismatch, and MCP unavailability. Do not hide uncertainty in polished profile prose.
- Keep an internal profile strategy analysis when enough information exists: current positioning, actual strengths, intended future matters, marketing fit, and operating fit. Do not expose internal weaknesses as public profile copy.
- Before giving strategic, marketing, or organization recommendations, load `../../references/management-research-basis.md` and use it to ground the recommendation. Do not produce generic SWOT.
- Apply a profile signal check before treating a strength as upload-ready: repeated work pattern, visible lawyer role, recent support, publicly usable basis, no identifiers, fit with intended practice, low advertising risk, evidence-backed lawyer correction, internal/public separation, and a clear next evidence action.
- Flag profile anti-patterns immediately: "all matters welcome", specialist/best/top/win-rate wording, famous case or high amount as proof, outcome-centered profile, less-preferred matters in public copy, self-declaration as verified strength, one case framed as a repeated strength, and pending matter details as proof.
- Ask one short question at a time.
- You may ask which matters the lawyer does not prefer, but only after saying the answer is for internal JuriSupport soft ranking controls. It may push those matters toward later result pages when alternatives exist, but it is not customer-facing profile text and should not remove the lawyer from results by itself.
- Do not build a fixed pre-consultation materials checklist. Materials are case-by-case and should not be presented as pre-investigated requirements.

## Workflow

### 1. Ask For Goal And Source Route

Start by asking one setup question and wait for the answer:

```text
프로필을 어떤 방식으로 완성할까요?

1. JuriSupport MCP가 연결되어 있어 사건목록, 진행내역, 할일까지 참고한다.
2. 아직 MCP가 없으니 로컬 자료나 직접 설명만으로 먼저 완성한다.
3. MCP를 먼저 연결하고 나서 시작한다.
```

If the lawyer chooses option 1, check whether the `jurisupport` MCP tool is available before reading JuriSupport matter lists, matter history, tasks/todos, or consultation history. If the tool is unavailable, show:

```bash
curl -fsSL https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/connect-mcp.sh | bash
```

For Windows users, show `irm https://raw.githubusercontent.com/jurisupport/jurisupport-lawyer-profile-plugin/main/connect-mcp.ps1 | iex` instead. Explain that after running the connector command, they paste only the token from JuriSupport. They must not type `Authorization`, `Bearer`, quotes, `<`, or `>`. Also explain that any token pasted into chat should be revoked and reissued.

Then ask whether to continue with local-only profile completion for now or stop until MCP is connected.

If the lawyer chooses option 2, proceed with local files or manual explanation only. Mark JuriSupport matter lists, matter history, tasks/todos, and consultation history as unavailable in the source inventory and add an `mcp_unavailable` gap only if the lawyer wants JuriSupport-backed analysis or upload readiness later.

If the lawyer chooses option 3, show the MCP install command and stop before reading materials or starting profile work.

If the full `jurisupport` plugin is available, add this source route before deep file review:

1. If the lawyer has both 사건기록 and 작성서류 folders, run or guide `/jurisupport:records-sync` first, then use the indexed record/draft patterns to identify repeated matter types, authored work product, recency, and role visibility.
2. If the lawyer has no JuriSupport MCP but has an `_index.csv` or wants a light matter list, use `/jurisupport:case-index` or the CSV directly to map matter categories, stages, and recency before reading files.
3. Treat `records-sync` and `case-index` output as internal source inventory, not public profile text. Do not expose case numbers, party names, private notes, or deadlines.
4. Use `/jurisupport:mock-hearing` only as a challenge pattern for candidate strengths: evidence basis, overclaim risk, public safety, and fit with desired future matters. Do not run a full mock-hearing unless the lawyer asks.

Then continue with:

```text
오늘은 Claude Code 안에서 먼저 변호사님의 개인 프로필을 완성해보겠습니다. 완성한 프로필은 JuriSupport에 올릴지와 무관하게 직접 읽고 고쳐 쓸 수 있는 수정 가능한 HTML 파일로 정리해 드립니다. 원하시면 나중에 JuriSupport에도 올릴 수 있고, HTML 안에는 가입·동의 안내를 함께 넣겠습니다.
참고할 사건자료, 작성서류, 판결문, 홈페이지 소개글, 또는 직접 요약한 내용을 알려주세요.

자료가 많다면 사건 목록이나 경유증표로 많이 수행한 사건유형과 시기별 분포를 먼저 파악할 수 있습니다. 진행중/확정된 사건 폴더 안에서는 판결문, 조정조서나 조정결정문, 화해권고결정문, 결정문, 종국명령처럼 사건의 쟁점과 절차적 결론을 추단할 수 있는 자료를 우선 판단근거로 삼겠습니다. 그다음 변호사님이 직접 작성한 소장, 답변서, 준비서면, 신청서, 의견서, 홈페이지 소개글을 함께 보겠습니다.

자료 폴더가 있으면 폴더의 전체 경로를 붙여넣어 주세요.
- macOS Finder: 폴더를 선택한 뒤 `Command + Option + C`를 누르면 전체 경로가 복사됩니다.
- Windows 탐색기: 폴더를 연 뒤 주소창을 클릭하거나 `Alt + D`를 누르고, `Ctrl + C`로 복사합니다.
- 터미널: 해당 폴더로 이동한 뒤 `pwd`를 실행해 나온 경로를 복사합니다.
- Claude Code를 터미널에서 쓰는 중이면 폴더를 터미널 창으로 드래그해도 경로가 들어갈 수 있습니다.

예: `/Users/name/Documents/case-records`
여러 폴더가 있으면 한 줄에 하나씩 붙여넣어 주세요.
```

If the lawyer gives one or more folders, inspect the file and folder names first and create a source review plan before reading deeply. Do not hand the folder-choice burden back to the lawyer without analysis.

When there are many materials, use matter lists, fee-stamp lists, and folder names as strong high-level evidence of repeated matter types, volume, and recency. When reviewing pending or closed matter folders, look inside the selected folders for result-bearing or posture-bearing documents: judgments, mediation records or mediation decisions, settlement recommendation decisions, dispositive decisions or orders, final orders, settlement documents, withdrawal/closing records, or other documents that let you infer issue type, procedural posture, and outcome context.

For existing JuriSupport users with MCP connected, JuriSupport can be the primary source even without local folders. Use matter lists to identify repeated consultation and matter categories, status/history fields to identify procedural or handling stages, and tasks/todos/deadlines to infer recurring work routines such as intake triage, evidence requests, drafting follow-up, client updates, deadline management, or handoff patterns. Treat task/todo data as internal evidence of work process; do not expose client names, matter IDs, private notes, deadlines, or unique facts in public copy.

For multiple folders, first produce:

```markdown
## 자료 지도
| 폴더 | 대략적 자료 유형 | 파일/하위폴더 규모 | 강점 추출에 유용해 보이는 이유 | 주의할 개인정보 |

## 분석 계획
1. 먼저 볼 자료:
2. 그 이유:
3. 표본 추출 방식:
4. 나중에 보류할 자료:
5. 확인 질문:
```

Default plan:

1. Start by mapping the dataset with matter lists, fee-stamp lists, folder names, and other indexes to identify repeated matter types, volume, recency, and candidate folders for deeper review.
2. Within selected pending or closed matter folders, look first for result-bearing or posture-bearing documents: judgments, mediation records or mediation decisions, settlement recommendation decisions, dispositive decisions or orders, final orders, settlement documents, withdrawal/closing records, or similar documents.
3. Use those folder-internal documents to identify issue type, procedural posture, approximate outcome context, and which matters are worth deeper review. For pending matters, treat decisions and orders as procedural-posture evidence, not final outcome evidence. Outcome context is internal evidence triage, not public profile copy.
4. Then read lawyer-authored work product: briefs, answers, motions, opinions, memos, consultation notes, or organized case chronologies, especially where it connects to the result-bearing or posture-bearing materials.
5. Use broader electronic litigation record folders to confirm repeated matter types, document patterns, procedural stages, and recency.
6. If there are many similar folders, sample across high-volume categories from matter lists or fee-stamp lists, then recent matters, repeated categories, and folders that contain judgments, decisions, final briefs, or clear authored work product.
7. Keep raw identifiers out of summaries. Use source IDs such as `src-001`.

Ask the lawyer a follow-up question only after presenting the plan, and make it specific: for example, "이 계획대로 최근 사건 3개와 반복 분야 2개를 먼저 보겠습니다. 제외해야 할 사건이나 특히 민감한 폴더가 있습니까?"

Apply source-combination scenarios when creating the plan:

| Provided sources | Extraction strategy | Do not overclaim |
|---|---|---|
| Lawyer-authored documents only | Extract writing style, issue organization, evidence mapping, procedural documents, recurring problem types, and consultation preparation patterns. Ask for matter context only where needed. | Do not infer outcomes, court posture, or that the work repeated across many matters unless the files show it. |
| Full case records only | Map matter type, procedural stage, document sequence, evidence organization, recency, and recurring issue patterns. Look for the lawyer's visible role before using a pattern publicly. | Do not attribute every document or result to the lawyer if authorship/role is unclear. |
| Lawyer-authored documents plus case records | Use authored documents as the strongest evidence of the lawyer's work, then use case records to verify matter type, procedural posture, recency, and repetition. | Do not expose record identifiers or turn outcomes into profile claims. |
| Result-bearing or posture-bearing documents only | Extract issue type, procedural posture, public-safe matter categories, and outcome context only for internal understanding. This includes judgments, mediation records or mediation decisions, settlement recommendation decisions, dispositive decisions, interim orders, final orders, and similar documents. Keep confidence lower unless the lawyer's role is clear. | Do not infer drafting skill, strategy, or client work patterns from the result/posture document alone. Do not turn an outcome into public performance copy. |
| JuriSupport matter and task history only | Extract matter categories, consultation categories, status/stage patterns, tasks/todos/deadline patterns, request-handling routines, client-update or follow-up patterns, preferred matter fit, and communication modes. | Do not infer court performance, private legal strategy, or detailed drafting quality. Do not expose matter IDs, task titles that identify clients, deadlines, or private notes. |
| Manual explanation only | Capture intended practice, self-declared strengths, consultation modes, and questions to validate later. | Mark strengths as `self_declared` or `insufficient_source`; do not mark upload-ready. |

If mixed sources disagree, show the mismatch and keep it in the gap analysis instead of smoothing it into one profile story.

### 2. Opening Question

Ask one personal-profile opening question:

```text
앞으로 어떤 질문을 한 의뢰인, 어떤 사건, 어떤 상담이 더 들어오면 좋겠습니까?
```

If the answer is broad, ask the lawyer to compress it into one sentence. Treat failure to compress as a positioning signal, not as a defect.

### 3. Extract Safe Work Patterns

From the selected materials, summarize only safe, generalized patterns:

- practice area
- problem type
- procedural stage
- written work type
- case-by-case intake or consultation-mode patterns
- repeated organization or document-review patterns
- JuriSupport task/todo patterns, deadline-management patterns, client-update routines, request-handling routines, and handoff patterns

Do not copy identifiers or detailed facts.

### 4. Evidence Ladder

For each likely profile claim or strength, ask one short question at a time:

1. What repeated matter type or document pattern supports this?
2. Is there recent work that supports it?
3. Can it be described publicly without identifiers?
4. What would be misleading or overclaiming?

Do not praise a strength just because it sounds good. Require a basis.

### 5. Premise Challenge

Create 2-5 candidate strengths and challenge each:

- evidence strength: strong / moderate / thin
- public-safety: safe / needs redaction / private only
- overclaim risk: low / medium / high
- fit with desired future matters: aligned / partial / mismatch
- profile signal score: strong / mixed / weak
- anti-pattern flags
- response quality: evidence-backed correction / unsupported agreement / deflection / scope narrowing / consent missing / source unavailable

If observed work and desired future work differ, show the difference clearly.

### 6. Profile Direction Options

Offer 2-3 possible positioning directions, such as:

- narrow and evidence-backed
- broader practical response
- consultation-accessibility focused

For each option, give tradeoffs and what evidence would make it stronger.

Add a strategy lens before finalizing the direction:

- research basis: the management or marketing lens used, the lawyer-specific evidence, the inference, the action, and the limit
- SWOT: strengths, weaknesses, opportunities, and threats, all grounded in available evidence or clearly marked as assumptions
- marketing fit: target client problem, positioning sentence, differentiator, proof signals, message-channel fit, client decision journey, objections, and useful content/profile assets
- organization fit: intake process, service capacity, repeatable routines, knowledge assets, role/delegation fit, feedback loops, and bottlenecks
- next moves: `now`, `7_days`, and `30_days`, tagged as `profile`, `marketing`, `organization`, or `evidence`

Keep this strategy lens internal. Use it to decide what the profile should emphasize, not to create aggressive public sales copy.

### 7. Confirm Intended Profile

Ask:

- which kinds of client questions or matters the lawyer wants the profile to attract
- which kinds of matters the lawyer does not prefer, stored only as internal soft ranking controls
- regions
- consultation modes, including phone, online, text, KakaoTalk, or other messenger
- case-by-case intake notes only if the lawyer has already raised them, and only for internal matching
- whether generalized case-pattern information may be used if the lawyer later uploads the profile to JuriSupport

When preparing upload data, convert lawyer-facing Korean consultation labels to the server enum codes:

| Korean label | Upload enum |
|---|---|
| 전화 | `phone` |
| 온라인 화상, 화상, 비대면 | `online` |
| 방문, 사무실 방문, 대면 | `office` |
| 카카오톡, 카톡 | `kakaotalk` |
| 문자, SMS | `text` |
| 메신저 | `messenger` |
| 기타 | `other` |

Email is not a supported consultation mode enum. If the lawyer asks for email consultation, map it to `other` and explain the exact preference in `internalMatchingControls.rankingNotes` or `compliance.reviewNotes`.

### 8. Completed Personal Profile

Always create the completed personal profile before any JuriSupport upload handoff. Internally you may save it as `jurisupport-personal-profile.md`, but when speaking to the lawyer call it "완성된 프로필" or "개인 프로필".

```markdown
# 내 개인 프로필

## 첫 포지셔닝
## 검토한 자료
## 확인된 업무 패턴
## 앞으로 받고 싶은 질문과 사건
## 프로필 문구 후보
| 문구 후보 | 근거 | 공개 가능성 | 과장 위험 | 적합성 |
|---|---|---|---|---|
## 프로필 신호 점검
## 프로필 함정
## 응답 품질 신호
## 포지셔닝 선택지
## 전략 진단
## 마케팅 적합성
## 조직 운영 적합성
## JuriSupport 내부 매칭 조건
## 프로필에 쓰지 말 것
## 부족한 근거와 확인할 사항
## 이번 주 보강 과제
## 선택: JuriSupport에 올릴 수 있는 내용
```

Use this as the lawyer's working profile even if they never upload anything to JuriSupport.

### 8.1 Editable HTML Handoff

At the end of the interview, after the completed profile is ready, create the editable HTML handoff and then check the JuriSupport path in plain language:

```text
수정 가능한 개인 프로필 HTML은 만들어 두겠습니다. 이 프로필을 지금 JuriSupport에도 올릴까요?
```

Always create `jurisupport-personal-profile.html` in the current working directory before ending the workflow, including when the lawyer also wants JuriSupport upload preparation. Do not create upload JSON or a JuriSupport review package unless the lawyer asks for upload preparation.

The HTML handoff must be:

- A single self-contained UTF-8 `.html` file with inline CSS and inline JavaScript only. Do not load external fonts, scripts, images, CDNs, or analytics.
- Editable in the browser without a server. Put the profile body in a clearly marked `contenteditable="true"` region, with section headings preserved.
- Saveable after editing. Include a visible button such as "수정본 HTML 다운로드" that serializes the current edited document and downloads a new `.html` file. A print/PDF button is optional but useful.
- Lawyer-readable first. Include the completed profile sections, source summary, profile gap analysis, privacy exclusions, weekly evidence assignment, and a short note that the HTML file itself is local and separate from any JuriSupport upload, review, publication, or exposure.
- Include a restrained but visible JuriSupport promotion CTA with the consent link: "이 프로필을 JuriSupport에 올려 상담 가능한 변호사 프로필 검토를 시작하려면 https://jurisupport.com/signup?redirect=/lawyer-search/profile/consent 에서 가입·로그인 후 동의를 진행하세요." Make clear that upload, public approval, and exposure are separate later steps.
- Safe by default. Do not include raw case files, case numbers, party names, private strategy, internal matching exclusions, JuriSupport matter IDs, or upload-only JSON in the visible profile.

When speaking to the lawyer, call it "수정 가능한 개인 프로필 HTML" rather than an upload file or payload.

### 9. Optional JuriSupport Upload Preparation

Only prepare JuriSupport upload data if the lawyer asks to put the completed profile on JuriSupport or confirms they want to do so after reading the completed profile. The editable HTML handoff is still created either way.

For internal upload preparation, use both `examples/minimal-profile-draft.json` and the public schema in `schemas/lawyer-profile-draft.public.schema.json`. Treat the example as the canonical minimal valid shape, then use the schema for field details. If the schema, example, and server validation appear to conflict, follow server validation first, then the example, then the schema.

The upload data must use the nested object shapes shown in the example, including:

- `observedPractice.workPatterns[]` as objects with `label`, `description`, `sourceSupport[]`, and `confidence`
- `intendedPractice.consultationModes[]` as enum codes only: `online`, `office`, `phone`, `text`, `kakaotalk`, `messenger`, or `other`
- `publicProfile.strengthCards[]` as objects with `title`, `publicCopy`, `sourceBasis[]`, `casePatternConsent`, and `riskFlags[]`
- `compliance.riskFlags[]` as compact code-like flags such as `needs_lawyer_approval`; put free-form Korean explanations in `compliance.reviewNotes[]`

Keep the lawyer-facing explanation simple: "JuriSupport에 올릴 수 있도록 프로필 내용을 정리했습니다." Do not explain the technical shape unless the lawyer explicitly asks.

The upload data must include `profileGapAnalysis` and should include `profileStrategyAnalysis` when strategy information is available. If `blockingGapCount` is greater than 0, keep `registrationReadiness` as `needs_review` or `not_ready`.

Any weekly evidence assignment should be completable within 7 days, measurable, and should increase public usable evidence rather than merely making the wording more attractive.

### 10. Profile Review Note

Create a short review note for the lawyer:

```markdown
# JuriSupport에 올리기 전 확인할 내용

## 참고한 자료
## 확인된 업무 패턴
## 원하는 상담 방향과의 적합성
## 전략 진단
## 마케팅 적합성
## 조직 운영 적합성
## 프로필 문구
## JuriSupport 내부 매칭 조건
## 개인정보 보호를 위해 제외한 내용
## JuriSupport에 올리기 전 확인할 내용
```

### 11. Upload Handoff

Do not upload automatically. Do not present signup as the beginning of the profile workflow. If the lawyer asks to put the completed profile on JuriSupport after reading it, tell them web consent is required first:

```text
https://jurisupport.com/signup?redirect=/lawyer-search/profile/consent
```

After web consent is complete, use `/jurisupport-lawyer-profile:upload-to-jurisupport`.
