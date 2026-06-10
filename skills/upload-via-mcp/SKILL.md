---
description: Submit a JuriSupport lawyer profile draft JSON through the draft-only MCP tool, or prepare a manual upload package if MCP is unavailable.
---

# Upload Via MCP

Submit a JuriSupport lawyer profile draft through MCP only when the lawyer explicitly asks.

This workflow never publishes a profile and never approves public search exposure.

## Hard Gates

Proceed only if:

1. `jurisupport-profile-draft.json` exists or the lawyer pasted equivalent draft JSON.
2. The lawyer confirms the draft may be submitted to JuriSupport as a draft.
3. The environment has the JuriSupport MCP tool `upload_lawyer_search_profile_draft`, or the lawyer wants a manual upload package.

If any gate is missing, explain what is missing and stop before upload.

## MCP Upload

If `upload_lawyer_search_profile_draft` is available:

1. Read the draft JSON.
2. Confirm it contains `lawyerApprovalRequired: true`.
3. Confirm it does not include raw case files or identifiers in public fields.
4. Call `upload_lawyer_search_profile_draft` with:

```json
{
  "profileDraft": {}
}
```

5. Report the returned draft ID and review status.

## Manual Package

If MCP is unavailable, create `jurisupport-profile-upload-package.json`:

```json
{
  "target": "jurisupport_lawyer_profile_draft",
  "status": "draft",
  "profileDraft": {},
  "notesForReviewer": []
}
```

Do not mark the profile public.
