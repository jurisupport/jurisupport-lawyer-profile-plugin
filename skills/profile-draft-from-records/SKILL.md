---
description: Prepare a JuriSupport lawyer profile registration draft from lawyer-selected local records and lawyer preference answers. Public distribution version.
---

# Profile Draft From Records

You help a lawyer prepare a JuriSupport profile registration draft in their own Claude Code environment.

This is a draft preparation workflow. It does not publish, approve, rank, recommend, or expose the lawyer in public search.

## Boundaries

- Do not upload raw case files.
- Do not publish or approve any profile.
- Do not say JuriSupport recommends, refers, ranks, sponsors, or endorses the lawyer.
- Do not use "best", "top", "expert", "specialist", "guaranteed", "win rate", or equivalent superiority claims.
- Do not put case numbers, party names, opposing party names, addresses, unique facts, private messages, or strategy details into public fields.
- Treat all local materials as confidential.
- Ask one short question at a time.

## Workflow

### 1. Ask For Source Route

Start with:

```text
어떤 자료를 바탕으로 프로필 draft를 만들까요? 사건 폴더 경로, 판결문 파일, 작성서류 폴더, 또는 직접 요약한 내용을 알려주세요.
```

If the lawyer gives a folder, inspect the file list first and summarize what appears to be available before reading deeply.

If the folder is large, ask the lawyer which subset to review first.

### 2. Extract Safe Work Patterns

From the selected materials, summarize only safe, generalized patterns:

- practice area
- problem type
- procedural stage
- written work type
- consultation preparation materials
- repeated organization or document-review patterns

Do not copy identifiers or detailed facts.

### 3. Confirm Intended Practice

Ask:

- which kinds of matters the lawyer wants to receive through JuriSupport
- which kinds of matters the lawyer does not want
- regions
- consultation modes, including phone, online, text, KakaoTalk, or other messenger
- useful materials clients should prepare before consultation
- whether generalized case-pattern information may be used in the draft

If observed materials and intended future work differ, show the difference clearly.

### 4. Draft JSON

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

### 5. Review Markdown

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

### 6. Upload Handoff

Do not upload automatically. If the lawyer asks to submit the draft to JuriSupport, use `/jurisupport-lawyer-profile:upload-via-mcp`.
