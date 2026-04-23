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

## Conventions
- Raw data is never modified — all processing in `_derived/`
- Every do-file starts by running `00_setup.do`
- Cross-language replication: Stata results replicated in R and Python

## Co-authors
[Names and roles if applicable]

---

## First-Time Setup (each co-author, once per machine)

### 1. Set your paths in `code/stata/00_setup.do`
Add a block for your username with your `$ProjectX` path (path to this project folder).

### 2. Create symlinks

`[project-name]_Overleaf/output/` must point to `[project-name]/output/` so figures and
tables update automatically when you recompile in Overleaf. `[project-name]/tex/` must
point to `[project-name]_Overleaf/` so Claude can read the .tex files.

**Windows** (run Command Prompt as Administrator):
```
mklink /D "[path to ProjectX_Overleaf]\output" "[path to ProjectX]\output"
mklink /D "[path to ProjectX]\tex" "[path to ProjectX_Overleaf]"
```

**Mac** (run in Terminal):
```
ln -s "[path to ProjectX]/output" "[path to ProjectX_Overleaf]/output"
ln -s "[path to ProjectX_Overleaf]" "[path to ProjectX]/tex"
```
