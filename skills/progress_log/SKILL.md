---
name: progress_log
description: End-of-session routine. Writes a session summary, syncs local AI memory into the project (so the other tool/machine can see it), updates MEMORY.md if needed, and commits & pushes. Use before switching from Claude to Codex (or vice versa) when hitting a quota limit, or at the end of any working session.
---

# Skill: progress_log

## When to invoke
- User says "log progress", "save session", "I'm switching to Codex/Claude", or "end of session".
- User has hit a daily/weekly quota and wants to switch tools.
- Before a long break where the next session may be in a different tool or on a different machine.

## What this skill does

Run the steps below in order. Ask before destructive operations (file deletes, force-push).

### Step 1 — Identify the project
- Determine `$PROJECT_ROOT` from the current working directory (the git repo root).
- Determine which tool is writing this log: Claude Code or Codex CLI. Use the assistant's own identity — do not ask.
- Determine the project's memory-directory slug:
  - Claude: `C:\Users\Kueng\.claude\projects\<slugified-project-path>\memory\`
    where the slug replaces `\`, `/`, `:` with `-` (e.g. `C--Users-Kueng-Dropbox-Research-Nathanson-PropertyInvestors-UndiversifiedLandlords_new`).
  - Codex: `C:\Users\Kueng\.codex\memories\<project-name>\` (may or may not exist).

### Step 2 — Write the session summary
Create `progress_logs/YYYY-MM-DD_<tool>-<machine>-<short-topic>.md` in the project root, where:
- `YYYY-MM-DD` is today's date (check `# currentDate` in context).
- `<tool>` is `claude` or `codex`.
- `<machine>` is the hostname of the current machine in lowercase (e.g. `laptop`, `pc`). Run `hostname` in bash if unsure.
- `<short-topic>` is 2–4 words describing the session's main work (e.g. `codex-setup`, `replication-figures`).

The file should contain:
```markdown
# Session: <one-line topic>

**Date:** YYYY-MM-DD
**Tool:** Claude Code (claude-opus-4-X) | Codex CLI (gpt-5.X)
**Working directory:** <absolute path>

## What I worked on
- Bullet list of concrete tasks/changes.

## Files changed
- path/to/file — one-line description

## Decisions & context
- Anything non-obvious the next session should know (why a choice was made, what was ruled out).

## Open TODOs
- [ ] Item 1
- [ ] Item 2

## Next session should start by
- Reading this log and MEMORY.md.
- <specific first step>
```

Keep it short — a page or less. Focus on *why* and *what's next*, not *what the diff already shows*.

### Step 3 — Sync local AI memory into the project
Copy memory files from the user's machine-specific locations into the project directory so they sync via Dropbox to other machines and are visible to the other AI tool.

- **Claude → project**: copy `*.md` files from
  `C:\Users\Kueng\.claude\projects\<slug>\memory\`
  into `$PROJECT_ROOT\.claude\memory\` (create the directory if it doesn't exist).

- **Codex → project**: copy `*.md` files from
  `C:\Users\Kueng\.codex\memories\<project-name>\`
  into `$PROJECT_ROOT\.codex\memories\` (create the directory if it doesn't exist).

Use overwrite-on-copy. If a local memory file doesn't exist, skip that side silently.

Note: `$PROJECT_ROOT\.claude\` and `$PROJECT_ROOT\.codex\` are listed in `.dropboxignore` with exceptions for `memory/` and `memories/` respectively, so only those subfolders sync.

### Step 4 — Update MEMORY.md and CLAUDE.md/AGENTS.md if useful
- If a finding from this session should persist across conversations, add or update an entry in `$PROJECT_ROOT\MEMORY.md` (the index). Keep entries to one line each.
- If a project convention changed, update `$PROJECT_ROOT\CLAUDE.md` and/or `$PROJECT_ROOT\AGENTS.md`. Both files should stay consistent in content that's not tool-specific.
- If nothing persistent was learned, skip this step.

### Step 5 — Commit and push
Show the user the list of files staged before committing. Then:
```
git add progress_logs/ .claude/memory/ .codex/memories/ MEMORY.md CLAUDE.md AGENTS.md
git commit -m "Progress log: <one-line topic> (YYYY-MM-DD, <tool>, <machine>)"
git push
```
Only `git add` paths that actually changed. Never blanket `git add -A` (could pick up scratch files or credentials).

### Step 6 — Tell the user what was done
One short summary: log file path, what was synced, commit hash, and (if switching tools) a one-line cue for the next session like:

> "Saved. Next session: start with `resume_session` skill, then continue on <next TODO>."

## Things this skill must NOT do
- Do not delete any files.
- Do not force-push.
- Do not commit files matching `*.dta`, `*.csv`, `*.xlsx`, credentials files, or anything in `.gitignore` — trust git to filter these, but warn if suspicious paths appear in `git status`.
- Do not invent TODOs the user didn't mention.
