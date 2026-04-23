---
name: resume_session
description: Start-of-session routine. Reads the latest progress log, synced memory, and project instructions, then summarizes where the user left off and what to do next. Counterpart to the progress_log skill.
---

# Skill: resume_session

## When to invoke
- User says "where did I leave off", "resume", "pick up where we left off", or starts a session with no other specific instruction.
- Beginning of any session on a project that uses the `progress_log` skill.

## What this skill does

### Step 1 — Gather context
Read these files (in order), skipping any that don't exist:

1. **Latest progress log** — most recent file in `progress_logs/` by filename date. If the latest is from a different tool (e.g. the last session was Codex and this one is Claude), note that explicitly.
2. **`MEMORY.md`** in the project root (index of persistent memories).
3. **`CLAUDE.md`** or **`AGENTS.md`** in the project root, whichever matches the current tool.
4. **Synced memory** from the other machine/tool:
   - Claude's memory: `.claude/memory/*.md`
   - Codex's memory: `.codex/memories/*.md`
   Only read files directly relevant to what the progress log points to — don't dump everything.
5. **`code/stata/00_setup.do`** (if the project has one) to see current path globals.

Avoid re-reading files already loaded automatically by the harness.

### Step 2 — Summarize to the user
Give a short briefing (under 10 lines) with these parts:

```
## Where you left off
<one-paragraph summary of the last session, including the tool used and the date>

## Open TODOs
- [ ] ...
- [ ] ...

## Suggested next step
<one concrete action the user can approve with "yes" or redirect>
```

Do not ask clarifying questions first. Give the summary, then wait for the user's response.

### Step 3 — Wait for the user's direction
Do not start editing code or running commands based on the summary alone. The user may want to:
- Continue the suggested next step → proceed.
- Pivot to something else → follow the new instruction.
- Discuss the plan first → answer questions.

## Things this skill must NOT do
- Do not modify any files.
- Do not run any commands that change state (no `git`, no `stata`, no builds).
- Do not guess at what to do next if the progress log is empty or missing — tell the user there's no prior context and ask what they'd like to work on.
