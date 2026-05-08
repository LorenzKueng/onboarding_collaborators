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
- `$OverleafRoot` — local path to Overleaf folder (set per user in `00_setup.do`; code writes output here; AI reads `.tex` via `tex/` symlink)

## Conventions
- Raw data is never modified — all processing in `_derived/`
- Every do-file starts by running `00_setup.do`
- Cross-language replication: Stata results replicated in R and Python

## Co-authors
[Names and roles if applicable]

---

## Session Start
Read `MEMORY.md` and the latest file in `progress_logs/` to orient yourself on current status.

---

## Gemini Usage Notes
- Gemini reads this `GEMINI.md` (equivalent of `CLAUDE.md` for Claude Code).
- The global file `~/.gemini/GEMINI.md` is a symlink to your `GEMINI_global.md` — edit the source, not the symlink.
- Skills are loaded from `~/.gemini/skills/` (symlinked to the shared `skills/` folder). Type `/skills` in a session to list them; invoke with `/skill-name`.
- Prefer Gemini for long-context tasks and when explicitly using Gemini models.

---

## First-time setup (per machine, per co-author)
See `SETUP.md` in this project's root.
