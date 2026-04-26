# Project: [Project Name]

## What This Project Is
[One paragraph description of the research question]

## Key Files
- `code/stata/master.do` — run this to execute the full pipeline
- `code/stata/00_setup.do` — sets all path globals; sourced at top of every do-file

## Stata Globals
- `$raw` — raw data folder (`data/raw/`)
- `$derived` — intermediate processed datasets (`data/_derived/`)
- `$output` — figures, tables, and other output (`output/`)
- `$OverleafRoot` — local path to Overleaf folder (set per user in `00_setup.do`; code writes output here; AI reads .tex via `tex/` symlink)

## Conventions
- Raw data is never modified — all processing in `_derived/`
- Every do-file starts by running `00_setup.do`
- Cross-language replication: Stata results replicated in R and Python

## Co-authors
[Names and roles if applicable]

---

## Session Start
At the start of each session, read `code/stata/00_setup.do` to know the current path globals (`$ProjectRoot`, `$OverleafRoot`, etc.).

---

## Codex Usage Notes
- Codex reads this `AGENTS.md` (equivalent of `CLAUDE.md` for Claude Code).
- The global file `~/.codex/AGENTS.md` is a symlink to your `AGENTS_global.md` — edit the source, not the symlink.
- Memory for Codex is stored in `~/.codex/memories/` (machine-specific). Sync across machines via the `progress_log` skill.
- Prefer Codex for execution-heavy work (large batches of edits, long autonomous runs). Prefer Claude Code for interactive work (planning, debugging, explaining).

---

## First-time setup (per machine, per co-author)
See `SETUP.md` in this project's root. Or invoke `/overleaf_workflow` for the LaTeX-specific bits.
