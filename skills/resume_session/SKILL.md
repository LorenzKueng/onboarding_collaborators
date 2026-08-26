---
name: resume_session
description: Start-of-session routine. Reads PROJECT_STATUS.md, the latest progress log, synced memory, and project instructions, then summarizes where the user left off and what to do next. Counterpart to the progress_log skill.
---

# Skill: resume_session

## When to invoke
- User says "where did I leave off", "resume", "pick up where we left off", or starts a session with no other specific instruction.
- Beginning of any session on a project that uses the `progress_log` skill.

## What this skill does

### Step 1 - Gather context
Read these files in order, skipping any that do not exist:

1. **`PROJECT_STATUS.md`** in the project root - treat it as the 5-minute dashboard and source of truth for current state, active TODOs, waiting items, key decisions, and files of record.
2. **Latest progress log** - most recent file in `progress_logs/` by filename date. If the latest is from a different tool (for example, the last session was Codex and this one is Claude), note that explicitly. Use it to fill in details missing from `PROJECT_STATUS.md`.
3. **`MEMORY.md`** in the project root - index of persistent project memory.
4. **`CLAUDE.md`**, **`AGENTS.md`**, or **`GEMINI.md`** in the project root, whichever matches the current tool.
5. **Synced tool memory** if configured:
   - Claude memory: `.claude/memory/*.md`
   - Codex memory: `.codex/memories/*.md`
   Only read files directly relevant to what the dashboard or latest progress log points to.
6. **Active Codex worklog** if running in Codex and the project uses one: check for `tasks/*/resume_prompt.md`, then read the matching `plan.md`, `notes.md`, `decisions.md`, `sources.md`, and `verification.md` as needed.
7. **`code/stata/00_setup.do`** if the project has one, to see current path globals.

Avoid re-reading files already loaded automatically by the host.

### Step 1b - Multi-AI / parallel-work safety check
If the resumed or newly selected task may involve multiple AIs, parallel agents, or more than one tool editing the same repo/project, ask before editing:

> Should I start this task in a separate Git worktree so Codex/Claude/Gemini do not edit the same working directory?

Recommended worktree folder naming:

```text
<person-or-team>-<tool>-<project>-YYYY-MM-DD
```

Do not create the worktree automatically unless the user agrees. For small single-agent edits, the current working directory is fine.

### Step 2 - Summarize to the user
Give a short briefing with these parts:

```markdown
## Where you left off
<one-paragraph summary of the last session, including the tool used and the date>

## Open TODOs
- [ ] ...
- [ ] ...

## Suggested next step
<one concrete action the user can approve with "yes" or redirect>
```

If running in Codex and an active `tasks/*/resume_prompt.md` exists, also show a short Codex worklog prompt telling the session which task folder to continue from.

Do not ask clarifying questions first. Give the summary, then wait for the user's direction.

### Step 3 - Wait for direction
Do not start editing code or running commands based on the summary alone. The user may want to continue the suggested next step, pivot, or discuss the plan first.

## Things this skill must NOT do
- Do not modify files.
- Do not run commands that change state.
- Do not guess what to do next if there is no prior context; say there is no prior context and ask what the user would like to work on.