# JuriSupport Lawyer Profile Claude Code Plugin

This is the public-distribution version of the JuriSupport lawyer profile drafting plugin.

It helps a lawyer use their own Claude Code environment to prepare a profile registration draft from lawyer-selected local materials such as:

- electronic litigation records downloaded by the lawyer
- judgments or decisions
- written work product
- short notes about JuriSupport matter history
- the lawyer's own preference about future consultation fit

The plugin creates a draft JSON for JuriSupport review. It does not publish a profile, approve public search exposure, rank lawyers, recommend lawyers, or upload raw case files.

## What Is Not Included

This public package intentionally does not include JuriSupport's private matching logic, internal approval policy, detailed evaluation rubrics, reviewer tooling, or operational data structures.

## Install For Local Testing

Clone this private repository:

```bash
git clone https://github.com/jurisupport/jurisupport-lawyer-profile-plugin.git
cd jurisupport-lawyer-profile-plugin
```

Run Claude Code with this plugin directory:

```bash
claude --plugin-dir .
```

In Claude Code:

```text
/jurisupport-lawyer-profile:profile-draft-from-records
/jurisupport-lawyer-profile:upload-via-mcp
```

If you are testing from the private planning workspace instead of a cloned repo, use:

```bash
claude --plugin-dir /Users/haheebong/Documents/jurisupport-lawyer-search-private/public-release/claude-code-plugins/jurisupport-lawyer-profile
```

## Data Handling

- Review only files or folders the lawyer selects.
- Do not upload raw case files.
- Do not include case numbers, party names, addresses, unique facts, private messages, or internal strategy in public profile fields.
- Send only a draft JSON through the JuriSupport MCP tool when the lawyer explicitly asks for draft submission.
- Draft submission does not make the profile public.

## Outputs

Typical local files:

- `jurisupport-profile-draft.json`
- `jurisupport-profile-review.md`
- `jurisupport-profile-upload-package.json`

Schema:

- `schemas/lawyer-profile-draft.public.schema.json`

Example:

- `examples/minimal-profile-draft.json`
