---
name: prompt
description: Format an informal/dictated request into a structured prompt and execute it. Use when the user gives a casual ask and wants Claude to format it cleanly first. Supports `depth:light/standard/deep` and an opt-in `council` token to route through `/council` instead of executing directly.
---

# /prompt — Format and Execute

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

7. **Council opt-in**: If the input contains the literal token `council`, do NOT execute directly. Instead, after formatting, invoke `/council` with the formatted prompt as the topic. The `council` token is opt-in only — `/prompt` does NOT default-wrap in council. This prevents accidental council dispatches from casual `/prompt` uses.

8. **Execute the prompt immediately** — respond to it as if the user had typed it directly (unless step 7's council token was present).

9. **Ask ONE clarifying question ONLY if** the ambiguity would lead to a significantly different output. Otherwise, make reasonable assumptions and proceed.

## Important
- Do NOT over-engineer simple requests. A 1-sentence ask doesn't need a 20-line prompt.
- Match complexity of formatting to complexity of task.
- Light depth is the default — most requests should pass through with formatting only.
- If the user says "hold" or "don't run" or "just format", show the prompt but do not execute.
- `council` token handling: opt-in only. `/prompt X depth:deep council` → format, then dispatch via `/council`. `/prompt X` → format + execute directly (no council).
- Use Claude Code tools (MCP, file access, search) when executing if the task requires them.
- **Numbered-list output convention.** When the executed response is a list of items the user might want to discuss individually — recommendations, findings, options, action items, file changes, decisions, open questions — present them as a numbered list (1., 2., 3., …). The user replies by item number ("Re 1. ... Re 2. ..."). Do NOT number prose answers, single-paragraph summaries, or code-only outputs. Sub-items use 1a, 1b for a second level.
- **Constraint blocks.** If the user includes `with: <name1>, <name2>` (e.g. `with: anti-bloat, voice-preservation`), expand each named block from formatting-core.md's "Reusable Constraint Blocks" table into the formatted prompt's Constraints section. The formatter MAY also auto-include a relevant block silently when the task strongly signals it.
- **Anti-pattern self-check.** Before showing the formatted prompt, scan for vague intensifiers ("be comprehensive"), ALL-CAPS urgency, and negative-only constraints. Rewrite per formatting-core.md's "Anti-Pattern Self-Check" table. The user sees only the cleaned-up version.
- **Ordering rule.** When the prompt includes a long document or many sources (~> 200 words of context), place them BEFORE the task in the formatted prompt. Place the question or instruction LAST.
