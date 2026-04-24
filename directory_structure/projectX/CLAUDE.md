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
- `$OverleafRoot` — local path to Overleaf folder (set per user in `00_setup.do`; use this to read `.tex` files)

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

## First-Time Setup (each co-author, once per machine)

### 1. Set your paths in `code/stata/00_setup.do`
Add a block for your username with your `$ProjectRoot` path and `$OverleafRoot` path.
Claude uses `$OverleafRoot` to read `.tex` files directly — no symlink needed for that purpose.

### 2. Overleaf output setup

Figures and tables are written directly to `$OverleafRoot/output/figures/` and `$OverleafRoot/output/tables/` by the code — globals set in `00_setup.do`. Dropbox syncs that real folder to Overleaf cloud. The `capture mkdir` commands in `00_setup.do` create the folders on first run. **No junction or symlink needed for `output/`.**

> **Why not use a junction?** Both the project folder and the Overleaf folder are inside Dropbox. Dropbox does not follow junctions/symlinks that point to other Dropbox folders. Writing directly to `$OverleafRoot/output/` is the reliable solution.

**One symlink IS needed** (per machine, excluded from Dropbox via `.dropboxignore`) — gives Claude a short `tex/` path to `.tex` files:

**Windows** (run Command Prompt — no admin required):
```
mklink /J "[path to ProjectX]\tex" "[path to ProjectX_Overleaf]"
```

**Mac** (run in Terminal):
```
ln -s "[path to ProjectX_Overleaf]" "[path to ProjectX]/tex"
```
