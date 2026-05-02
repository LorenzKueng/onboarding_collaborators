# Prompt Formatting Core — Shared Reference

*v2.2 — Adds content-ordering rule, reusable constraint blocks, and anti-pattern self-check (sourced from claudeblattman.com/essentials/prompting/, 2026-05-03).*

---

## Formatting Elements

When formatting a prompt, apply these elements as appropriate (not all are needed for every prompt):

- **Role/persona** — include only when specialized expertise sharpens the output
- **Task** — stated clearly in 1-2 sentences (always include)
- **Context** — relevant background the model needs
- **Constraints** — length, tone, format, what to avoid
- **Output format** — specify structure (bullets, table, sections, etc.)
- **Bookend pattern** — restate the key instruction at the end if the prompt is long
- **Examples** — include only if they would reduce ambiguity (try zero-shot first)

**Scaling rule:** Match formatting complexity to task complexity. A 1-sentence ask doesn't need a 20-line prompt.

**Ordering rule:** When the prompt includes a long document or many sources, place them BEFORE the task. Place the question or instruction LAST. Anthropic reports up to ~30% quality uplift on complex/multi-document inputs from this ordering. For short prompts (< ~200 words of context), order doesn't matter.

---

## Depth Calibration

Before formatting, assess how much depth this task needs. **Default to Light** (format only). Depth injection is additive, not automatic.

### Heuristic

| Level | When to use | User override |
|-------|-------------|---------------|
| **Light** | Default. Quick replies, simple lookups, routine tasks, short emails | `depth:light` |
| **Standard** | Analysis, research, writing, or design where output quality depends on rigor | `depth:standard` |
| **Deep** | High stakes: methodology, identification strategy, grant proposals; or when user explicitly asks for thoroughness | `depth:deep` |

### Escalation signals (upgrade from Light)

- Task involves synthesis, analysis, or original argument → **Standard**
- Task involves research design, causal inference, or policy implications → **Standard** or **Deep**
- Words like "comprehensive," "thorough," "rigorous" in the request → **Standard** or **Deep**
- High-stakes deliverables (pre-analysis plan, grant proposal, methodology section) → **Deep**

---

## Depth-Injection Templates

### Light (default)
No injection. Format the prompt using the elements above. Done.

### Standard — append to formatted prompt:
```
Include at the end:
- Key assumptions (2-3 bullets)
- Brief rationale for major choices
```

### Deep — append to formatted prompt:
```
Before answering:
- Research current best practices for [task domain]
- Compare your approach against established standards in [domain]
- Flag where your approach deviates and why

Include at the end:
- Key assumptions (2-3 bullets)
- Brief rationale for major choices
- What you verified and what remains uncertain
```

---

## Reusable Constraint Blocks

Five named blocks the formatter (or user) can include by name. Add only when the task signals the corresponding risk — don't bolt all five onto every prompt.

| Name | When to include | Block text |
|------|-----------------|------------|
| **anti-hallucination** | Citation- or fact-heavy tasks (lit reviews, grant background, anything quoting sources) | `If a fact is not in the provided sources, write "not in source" rather than inferring or fabricating. Do not invent citations.` |
| **anti-bloat** | Edits, rewrites, single-paragraph asks; anywhere preamble would just be noise | `Reply with only the requested content. No "Here is..." preamble and no closing summary.` |
| **scope-guard** | Underspecified asks where assumptions could change the answer materially | `If you need information not provided (e.g., sample period, dependent variable, audience) to answer well, ask before proceeding instead of guessing.` |
| **structured-uncertainty** | High-stakes analytical tasks; methodology choices; anything I'll defend | `End with three short lists: Assumptions / Verified / Still unknown.` |
| **voice-preservation** | Editing my own writing (drafts, emails, paper sections) | `Edit for clarity but preserve my sentence rhythm, register, and contractions. Do not formalize the prose.` |

**User invocation:** the user can include them by name in the request, e.g. `/prompt rewrite this paragraph with: voice-preservation, anti-bloat`. The formatter expands the named blocks into their full text inside the formatted prompt's Constraints section.

**Formatter auto-include:** if no `with:` clause is present, the formatter MAY add a relevant block when the task strongly signals it (e.g., add `anti-hallucination` for any "summarize this paper" task with sources). Include silently — no need to call it out in the response.

---

## Anti-Pattern Self-Check

Before showing the formatted prompt, scan it for these patterns and rewrite if present:

| Anti-pattern | Why it hurts | Fix |
|---|---|---|
| Vague intensifiers ("be comprehensive", "be thorough", "be meticulous") | Newer models overthink; output bloats | Replace with the specific action: "check every numerical claim against the source PDF" |
| ALL-CAPS urgency ("CRITICAL: YOU MUST...") | Doesn't increase compliance; signals panic | Calm, specific directive: "If a citation isn't in the bibliography, write [citation needed] instead of inventing one." |
| Negative-only constraints ("don't write in jargon") | Leaves the model guessing what TO do | Pair the ban with a positive example: "...write the way you'd explain it to a smart undergraduate." |
| Missing pushback permission on judgment-call tasks | Model hedges instead of disagreeing | Add: "If you think my approach is wrong, say so directly — don't hedge." |

This is a self-edit on the formatted prompt, not a separate output. The user sees the cleaned-up version in the fenced code block.

---

## Tool-Routing Awareness

After formatting, check whether the task is better suited to another tool. Brief note, not blocking.

| Signal | Suggested tool | Reason |
|--------|---------------|--------|
| Deep multi-source literature review, "find everything about X" | ChatGPT Deep Research | Better web synthesis |
| Citation-heavy factual lookup, sourced answers | Perplexity | Inline citations, live sources |
| Heavy spreadsheet work (formulas, pivots, formatting) | Gemini | Native Sheets integration |
| Video/audio analysis | Gemini | Can process media directly |
| Otherwise | Proceed in Claude Code | Strong at reasoning, editing, local files |

**For `/prompt`**: Add a brief note before executing if another tool would serve better.
**For `/prompt-only`**: Add `**Best run in:** [tool] — [reason]` after the code block.
**For `/prompt-refine`**: Note in the changes list if the refined prompt would benefit from a specific tool.
