---
description: Put a lawyer-confirmed completed profile on JuriSupport after web consent.
---

# Upload To JuriSupport

Put a completed personal profile on JuriSupport only when the lawyer explicitly asks.

This workflow receives the completed profile prepared by `/jurisupport-lawyer-profile:complete-personal-profile`. It never publishes a profile and never approves public exposure by itself.

This is not the beginning of the lawyer onboarding process. If the lawyer has not completed a personal profile yet, route them back to `/jurisupport-lawyer-profile:complete-personal-profile` before discussing signup, consent, or upload.

Web consent is mandatory. Do not treat chat confirmation as upload consent. In user-facing language, say "완성한 프로필을 JuriSupport에 올린다". Do not lead with filenames, JSON, payload, package, draft, schema, or other technical packaging words unless troubleshooting requires it.

Before checking upload gates, tell the lawyer that upload requires the `jurisupport` MCP connection in Claude Code. If it is missing, stop before upload and show:

```bash
claude mcp add --transport http jurisupport https://api.jurisupport.com/mcp --header "Authorization: Bearer <MCP_TOKEN>"
```

After the profile is complete and the lawyer wants to upload it, the lawyer must complete the JuriSupport web consent page:

```text
https://jurisupport.com/signup?redirect=/lawyer-search/profile/consent
```

## Hard Gates

Proceed only if:

1. A completed profile exists or the lawyer pasted the completed profile content.
2. The lawyer has completed the web consent page at `/lawyer-search/profile/consent`.
3. The lawyer confirms the completed profile may be uploaded to JuriSupport.
4. Upload data includes `profileGapAnalysis` and `blockingGapCount` is 0. If the field is missing or blocking gaps remain, route back to profile review instead of uploading.
5. The environment has the JuriSupport MCP tool `upload_lawyer_search_profile_draft`.

If any gate is missing, explain what is missing and stop before upload.

## Upload Data Shape

Before calling the tool, compare the prepared upload data against `examples/minimal-profile-draft.json` first and `schemas/lawyer-profile-draft.public.schema.json` second. If the example, schema, and server validation appear to conflict, follow server validation first, then the example, then the schema.

The payload must use server enum codes and nested object shapes, not lawyer-facing Korean labels:

- `observedPractice.workPatterns[]`: `{label, description, sourceSupport[], confidence}`
- `intendedPractice.consultationModes[]`: `online`, `office`, `phone`, `text`, `kakaotalk`, `messenger`, or `other`
- `publicProfile.strengthCards[]`: `{title, publicCopy, sourceBasis[], casePatternConsent, riskFlags[]}`
- `compliance.riskFlags[]`: code-like flags; put free-form Korean notes in `compliance.reviewNotes[]`

## MCP Availability Diagnostics

If `upload_lawyer_search_profile_draft` is not visible in the current session, diagnose before falling back:

1. Run or ask the user to run `claude mcp list`.
2. If `jurisupport` is disconnected or shows `Failed to connect`, register it with Streamable HTTP:

```bash
claude mcp add --transport http jurisupport https://api.jurisupport.com/mcp --header "Authorization: Bearer <MCP_TOKEN>"
```

3. If `jurisupport` is connected but `upload_lawyer_search_profile_draft` is still absent, explain that the server deployment or account permission may not include the upload tool yet. Do not upload manually.
4. If the MCP was just added or changed during this Claude Code session, explain that the current session may not reload newly added MCP tools until Claude Code is restarted. Ask the lawyer to restart the session before retrying the MCP upload.

## MCP Upload

If `upload_lawyer_search_profile_draft` is available:

1. Read the completed profile and the internal upload data if present.
2. Confirm it contains `lawyerApprovalRequired: true`.
3. Confirm `profileGapAnalysis.blockingGapCount` is 0.
4. Confirm it does not include raw case files or identifiers in public fields.
5. Call `upload_lawyer_search_profile_draft` with the prepared profile data.
6. If the tool returns `PROFILE_UPLOAD_CONSENT_REQUIRED`, stop and tell the lawyer to complete the web consent page. Do not retry until consent is recorded.
7. Report that the profile was received by JuriSupport and is waiting for review. Do not emphasize technical IDs unless the lawyer asks.

## Manual Package

If MCP is unavailable, do not upload. Show the MCP install command first, then prepare a concise reviewer handoff note in plain Korean only if the lawyer explicitly asks for a non-MCP handoff artifact:

- the completed profile text
- the consultation areas and desired client questions
- privacy exclusions
- notes that need JuriSupport review

Do not mark the profile public.
