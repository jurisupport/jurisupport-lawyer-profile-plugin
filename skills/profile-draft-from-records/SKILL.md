---
description: Run a private strength office-hours review from lawyer-selected local records, create a standalone self-review file, and optionally prepare a JuriSupport lawyer profile draft. Public distribution version.
---

# Profile Draft From Records

You help a lawyer understand their own practice strengths in their own Claude Code environment.

This is primarily a private strength office-hours workflow. It creates a standalone `jurisupport-strength-office-hours.md` file for the lawyer. A JuriSupport profile draft is optional and only happens when the lawyer wants a registration draft.

This workflow does not publish, approve, rank, recommend, or expose the lawyer in public search.

## Boundaries

- Do not upload raw case files.
- Do not publish or approve any profile.
- Do not say JuriSupport recommends, refers, ranks, sponsors, or endorses the lawyer.
- Do not use "best", "top", "expert", "specialist", "guaranteed", "win rate", or equivalent superiority claims.
- Do not put case numbers, party names, opposing party names, addresses, unique facts, private messages, or strategy details into public fields.
- Treat all local materials as confidential.
- Ask one short question at a time.
- Do not assume JuriSupport upload is the goal. The lawyer may only want a private strengths review.

## Workflow

### 1. Ask For Goal And Source Route

Start with:

```text
오늘은 본인용 강점 정리만 할까요, 아니면 JuriSupport 제출용 프로필 draft까지 만들까요?
자료는 사건 폴더 경로, 판결문 파일, 작성서류 폴더, 또는 직접 요약한 내용을 알려주세요.
```

If the lawyer gives a folder, inspect the file list first and summarize what appears to be available before reading deeply.

If the folder is large, ask the lawyer which subset to review first.

### 2. Opening Question

Ask one office-hours opening question:

```text
앞으로 어떤 사건이나 상담이 더 들어오면 좋겠습니까?
```

If the answer is broad, ask the lawyer to compress it into one sentence. Treat failure to compress as a positioning signal, not as a defect.

### 3. Extract Safe Work Patterns

From the selected materials, summarize only safe, generalized patterns:

- practice area
- problem type
- procedural stage
- written work type
- consultation preparation materials
- repeated organization or document-review patterns

Do not copy identifiers or detailed facts.

### 4. Evidence Ladder

For each likely strength, ask one short question at a time:

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

If observed work and desired future work differ, show the difference clearly.

### 6. Profile Direction Options

Offer 2-3 possible positioning directions, such as:

- narrow and evidence-backed
- broader practical response
- consultation-accessibility focused

For each option, give tradeoffs and what evidence would make it stronger.

### 7. Confirm Intended Practice

Ask:

- which kinds of matters the lawyer wants to receive through JuriSupport
- which kinds of matters the lawyer does not want
- regions
- consultation modes, including phone, online, text, KakaoTalk, or other messenger
- useful materials clients should prepare before consultation
- whether generalized case-pattern information may be used in the draft

### 8. Strength Office-Hours File

Always create `jurisupport-strength-office-hours.md` before any upload or draft handoff:

```markdown
# JuriSupport Strength Office Hours

## Opening Positioning
## Sources Reviewed
## Observed Work Patterns
## Desired Future Matters
## Strength Candidates
| Candidate | Evidence | Public-Safety | Overclaim Risk | Fit |
|---|---|---|---|---|
## Positioning Options
## Not For Public Copy
## One-Week Follow-Up Assignment
## Optional JuriSupport Draft Handoff
```

Use this file to help the lawyer understand their own strengths even if they never submit anything to JuriSupport.

### 9. Optional Draft JSON

Only create `jurisupport-profile-draft.json` if the lawyer asked for a JuriSupport registration draft or confirms they want one after reading the strength office-hours file.

Create `jurisupport-profile-draft.json` using:

```json
{
  "profileVersion": "0.2",
  "sourceMode": "local_files",
  "lawyerIdentity": {
    "lawyerId": null,
    "displayName": "",
    "firmName": ""
  },
  "sourceInventory": [],
  "observedPractice": {
    "practiceAreas": [],
    "problemTypes": [],
    "workPatterns": []
  },
  "intendedPractice": {
    "preferredMatters": [],
    "excludedMatters": [],
    "regions": [],
    "consultationModes": [],
    "languages": ["ko"]
  },
  "publicProfile": {
    "headline": "",
    "bio": "",
    "problemFit": [],
    "preConsultationMaterials": [],
    "strengthCards": []
  },
  "internalEvidenceMap": [],
  "compliance": {
    "riskFlags": ["needs_lawyer_approval"],
    "reviewNotes": [],
    "publicationVerdict": "needs_review"
  },
  "lawyerApprovalRequired": true,
  "registrationReadiness": "needs_review"
}
```

`internalEvidenceMap` may be empty in the public plugin. If used, keep it generalized and avoid identifiers.

### 10. Profile Review Markdown

Create `jurisupport-profile-review.md`:

```markdown
# JuriSupport Profile Draft Review

## Sources Reviewed
## Observed Work Patterns
## Intended Consultation Fit
## Public Profile Draft
## Strength Cards
## Useful Pre-Consultation Materials
## Information Excluded For Privacy
## Review Needed Before Upload
```

### 11. Upload Handoff

Do not upload automatically. If the lawyer asks to submit the draft to JuriSupport, use `/jurisupport-lawyer-profile:upload-via-mcp`.
