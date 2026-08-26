---
name: progress_log
description: End-of-session routine. Writes a session summary, syncs local AI memory into the project, updates PROJECT_STATUS.md and MEMORY.md if useful, then commits and pushes. Use before switching tools or ending a work session.
---

# Skill: progress_log

## When to invoke
- User says "log progress", "save session", "I'm switching to Codex/Claude/Gemini", or "end of session".
- User has hit a quota and wants to switch tools.
- Before a long break where the next session may happen in a different tool or on a different machine.

## What this skill does

**Effort-steering preamble:** This skill is structured and templated. Extract facts from the conversation into slots and write outputs. Prioritize responding quickly over re-analyzing work the conversation already covered.

**File-write discipline:** Use atomic file writes/edits where your tool supports them for `PROJECT_STATUS.md`, `MEMORY.md`, `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, progress logs, and synced memory files. Avoid non-atomic shell redirection for these files because cloud sync can catch partially written content. If you see a conflicted cloud-sync copy, stop and surface it to the user before continuing.

**Run it one-shot.** Ask for the standard permission batch up front, then run the approved work end-to-end without repeated confirmations. The normal flow writes logs/status/memory, stages specific files, commits, and pushes. Do not force-push or delete files.

**Ask for every permission up front, once.** The standard batch is:
- Write/Edit: `PROJECT_STATUS.md`, the progress-log file, synced memory files under `.claude/memory/` or `.codex/memories/`, and `MEMORY.md` / `CLAUDE.md` / `AGENTS.md` / `GEMINI.md` if updated.
- Shell: `hostname`, memory copy commands if needed, `git add <specific paths>`, `git commit`, `git push`, and optional `mv` / `Move-Item` only if old progress logs are archived.

Hard stops: pause and tell the user if you find conflicted cloud-sync files, suspicious staged paths, credentials, data files, or any operation outside this normal non-destructive flow.

### Step 0 - Calibrate session size
Skim the conversation length:
- **Brief** (< about 10 user turns): write a compact log and skip long background.
- **Medium / extended**: use the full template below.

### Step 1 - Identify the project
- Determine the project root from the current working directory or git repo root.
- Determine which tool is writing this log: Claude, Codex, Gemini, or another assistant.
- Determine the machine name with `hostname` if needed.
- Determine whether the project has multiple collaborators from `CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, or the README.

### Step 2 - Write the session summary
Create a file in `progress_logs/` in the project root. Use one of these naming patterns:
- Solo project: `YYYY-MM-DD_<tool>-<machine>-<short-topic>.md`
- Multi-collaborator project: `YYYY-MM-DD_<tool>-<machine>-<initials>-<short-topic>.md`

The file should contain:

```markdown
# Session: <one-line topic>

**Date:** YYYY-MM-DD
**Tool:** <tool/model if known>
**Working directory:** <absolute path>

## What I worked on
- Bullet list of concrete tasks/changes.

## Files changed
- path/to/file - one-line description

## Decisions & context
- Anything non-obvious the next session should know.

## Open TODOs
- [ ] Item 1
- [ ] Item 2

## Next session should start by
- Reading this log and PROJECT_STATUS.md.
- <specific first step>
```

Keep it short. Focus on what changed, why, and what comes next.

### Step 3 - Sync local AI memory into the project
If the workflow has machine-specific AI memory, copy it into the project so it syncs across machines and is visible to other tools.

Common patterns:
- Claude memory: copy `*.md` from `~/.claude/projects/<project-slug>/memory/` into `$PROJECT_ROOT/.claude/memory/`.
- Codex memory: copy `*.md` from `~/.codex/memories/<project-name>/` into `$PROJECT_ROOT/.codex/memories/`.

Use overwrite-on-copy. If a local memory folder does not exist, skip it silently.

### Step 4 - Update PROJECT_STATUS.md
Maintain `$PROJECT_ROOT/PROJECT_STATUS.md` as the project's 5-minute dashboard. If it does not exist, create it.

Recommended structure:

```markdown
# PROJECT STATUS - <project name>

**Last updated:** YYYY-MM-DD
**Read first:** This file is the 5-minute dashboard. Detailed history lives in `progress_logs/`.

## Executive Summary
<one short paragraph: what this project is, where it stands, and the next decision point>

## Current State
- **Phase:** ...
- **Current file of record:** ...
- **Next deadline / meeting:** ...

## Active TODOs
- [ ] ...

## Waiting / Blocked
- [ ] ...

## Key Decisions
- YYYY-MM-DD: ...

## Recently Completed
- [x] YYYY-MM-DD: ...

## Files Of Record
- `path` - why it matters.

## Session Log Summaries
### YYYY-MM-DD - <topic>
<3-5 sentence summary, newest first>
```

Update it as follows:
- Refresh the executive summary/current state only when changed.
- Keep `Active TODOs` limited to current actionable items.
- Move completed items to `Recently Completed`.
- Add the newest session summary at the top of `Session Log Summaries`.
- Keep detailed chronology in `progress_logs/`, not in the dashboard.

### Step 5 - Update MEMORY.md and project instructions if useful
- If a finding should persist across conversations, add or update a concise entry in `MEMORY.md`.
- If a project convention changed, update the relevant project instruction files (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`) and keep shared content consistent.
- If nothing persistent was learned, skip this step.

### Step 6 - Optional security review
If this session involved writing new code that reads files, calls external APIs, handles credentials, or downloads data, run the project's security-review workflow first if one exists. Skip for documentation-only work.

### Step 7 - Optional archive of old progress logs
Count files in `progress_logs/` excluding `_archive/`:

| File count | Action |
|---|---|
| > 100 | Move logs older than 60 days into `progress_logs/_archive/YYYY/` |
| > 60 | Move logs older than 180 days into `progress_logs/_archive/YYYY/` |
| <= 60 | No-op |

If archiving fails, report the error and continue. Archiving is non-blocking.

### Step 8 - Commit and push
Commit and push without another confirmation once the initial permission batch was approved.

Stage only paths that actually changed, for example:

```bash
git add PROJECT_STATUS.md progress_logs/ .claude/memory/ .codex/memories/ MEMORY.md CLAUDE.md AGENTS.md GEMINI.md
git commit -m "Progress log: <one-line topic> (YYYY-MM-DD, <tool>, <machine>)"
git push
```

Never blanket `git add -A`; it could pick up scratch files, data, or credentials.

### Step 9 - Tell the user what was done
Give one short summary: log file path, dashboard update, memory sync if any, commit hash, and the next session's starting cue.

## Things this skill must NOT do
- Do not delete files.
- Do not force-push.
- Do not commit data files (`*.dta`, `*.csv`, `*.xlsx`), credentials, secrets, private transcripts, or ignored files.
- Do not invent TODOs the user did not mention.