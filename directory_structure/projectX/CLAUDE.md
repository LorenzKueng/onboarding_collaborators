# Project: [Project Name]

## What This Project Is
[One paragraph description of the research question]

## Key Files
- `code/stata/master.do` — run this to execute the full pipeline
- `code/stata/00_setup.do` — sets all path globals; sourced at top of every do-file

## Stata Globals
- `$raw` — raw data folder (`data/raw/`)
- `$derived` — intermediate processed datasets (`data/_derived/`)
- `$figures` — output figures (written to `$OverleafRoot/output/figures/`)
- `$tables` — output tables (written to `$OverleafRoot/output/tables/`)
- `$OverleafRoot` — local path to Overleaf folder (set per user in `00_setup.do`; code writes output here; AI reads .tex via `tex/` symlink)

## Conventions
- Raw data is never modified — all processing in `_derived/`
- Every do-file starts by running `00_setup.do`
- Cross-language replication: Stata results replicated in R and Python

## Co-authors
[Names and roles if applicable]

## Session Start
Read `code/stata/00_setup.do` to see current path globals (`$ProjectRoot`, `$OverleafRoot`, etc.).

## First-time setup (per machine, per co-author)
See `SETUP.md` in this project's root. Or invoke `/overleaf_workflow` for the LaTeX-specific bits.
