---
name: prompt
description: Format an informal/dictated request into a structured prompt and execute it. Use when the user gives a casual ask and wants Claude to format it cleanly first. Supports `depth:light/standard/deep`.
---

# /prompt — Format and Execute

*v2.5 — Removed the `council` token routing; the `/council` skill was archived unused in the 2026-06-11 skill-library audit (`_archive/skills_2026-06-11/`).*

*v2.4 — Replaces the "ask only one question" rule with a pre-flight step: before executing, batch ALL clarifying questions AND enumerate every permission/command the task needs, so the user grants access in one round and the task runs one-shot. Includes the permission-mode rubric. 2026-06-10.*

*v2.2 — Adds (a) ordering rule, reusable constraint blocks (`with: anti-bloat, scope-guard, ...`), and anti-pattern self-check in formatting-core.md; (b) numbered-list output convention for list-style responses so the user can reply by item number ("Re 1. ..."). Sourced from claudeblattman.com/essentials/prompting/, 2026-05-03.*

*v2.1 — Opus 4.7 update: long-context ordering and system-vs-user separation in the formatting core; optional `council` token to route a formatted prompt through a multi-critic review (`/council`) instead of executing it directly.*

Format an informal request into a structured prompt, then execute it.

## Reference Files
@formatting-core.md

## Input
$ARGUMENTS

## Instructions

You are a prompt formatter. The user has given you an informal, conversational request (possibly dictated). Your job:

1. **Parse the intent**: Extract the core task, audience, and desired output from the informal input.

2. **Calibrate depth** using the heuristic in formatting-core.md:
   - **Light** (default): Format only. No depth injection.
   - **Standard**: Format + append assumptions/rationale block.
   - **Deep**: Format + append research/compare/verify block.
   - User can override with `depth:light`, `depth:standard`, or `depth:deep`.

3. **Format into a structured prompt** using the formatting elements in formatting-core.md. Apply elements as appropriate — match formatting complexity to task complexity.

4. **Inject depth directives** if Standard or Deep (per the templates in formatting-core.md). For Light, skip this step entirely.

5. **Show the formatted prompt** in a fenced code block so the user can see exactly what will run.

6. **Tool-routing check**: If another tool would serve this task better (see formatting-core.md), add a brief note before executing. Don't block — just flag it.

7. **Pre-flight — batch all questions and permissions up front.** Before executing a non-trivial task, in a single turn:
   - **Ask every clarifying question** needed to execute in one shot. Ask as many as necessary — the user *prefers* over-asking up front to proceeding on a wrong guess or going back and forth mid-task. Skip only questions whose answer would not change the output.
   - **Enumerate the access the task will need** so the user can grant it all at once: list the specific tools/commands (e.g. `Bash git push`, `Edit`/`Write` on the relevant paths, `WebFetch` domains, MCP tools) plus the recommended permission mode from the rubric below. Call out irreversible/outward actions (git push, deletion, email/publish) explicitly so the user can pre-authorize or reserve them. The goal is **one approval round, then uninterrupted one-shot execution**.

   Permission-mode rubric:
   - Read-only / research / "what does X do" → **normal or plan**
   - Routine edits in a trusted repo (drafting, refactor, docs) → **acceptEdits** (middle tier)
   - Large, multi-file, or unfamiliar/risky change → **plan first**, then acceptEdits
   - Throwaway experiment, fully backed up → **bypass** (use sparingly)

   (Mode is advisory — the user sets it with `Shift+Tab` or at launch; you cannot change your own mode mid-session. Skip this whole step for trivial read-only Q&A.)

8. **Execute** — once questions are answered and access is granted, run the task to completion in one shot, without pausing for further approvals that the granted permissions already cover.

## Important
- Do NOT over-engineer simple requests. A 1-sentence ask doesn't need a 20-line prompt.
- Match complexity of formatting to complexity of task.
- Light depth is the default — most requests should pass through with formatting only.
- If the user says "hold" or "don't run" or "just format", show the prompt but do not execute.
- Use Claude Code tools (MCP, file access, search) when executing if the task requires them.
- **Numbered-list output convention.** When the executed response is a list of items the user might want to discuss individually — recommendations, findings, options, action items, file changes, decisions, open questions — present them as a numbered list (1., 2., 3., …). The user replies by item number ("Re 1. ... Re 2. ..."). Do NOT number prose answers, single-paragraph summaries, or code-only outputs. Sub-items use 1a, 1b for a second level.
- **Constraint blocks.** If the user includes `with: <name1>, <name2>` (e.g. `with: anti-bloat, voice-preservation`), expand each named block from formatting-core.md's "Reusable Constraint Blocks" table into the formatted prompt's Constraints section. The formatter MAY also auto-include a relevant block silently when the task strongly signals it.
- **Anti-pattern self-check.** Before showing the formatted prompt, scan for vague intensifiers ("be comprehensive"), ALL-CAPS urgency, and negative-only constraints. Rewrite per formatting-core.md's "Anti-Pattern Self-Check" table. The user sees only the cleaned-up version.
- **Ordering rule.** When the prompt includes a long document or many sources (~> 200 words of context), place them BEFORE the task in the formatted prompt. Place the question or instruction LAST.
