---
name: overleaf_workflow
description: How LaTeX writing is organized via Overleaf + Dropbox + symlinks. Invoke when the user asks about Overleaf, .tex files, the `tex/` symlink, or where figures/tables should be written.
---

# Skill: overleaf_workflow

## How it's set up
- LaTeX files live in Overleaf (browser-based). Each research project has a matching `[project-name]_Overleaf/` folder in Dropbox that Overleaf syncs to.
- Figures and tables are written directly to `$OverleafRoot/output/figures/` and `$OverleafRoot/output/tables/` by the Stata/R/Python code. Dropbox syncs that real folder to Overleaf cloud automatically.
- `$OverleafRoot` is set per user in each project's `code/stata/00_setup.do`.

## No junction or symlink for `output/`
Both the project folder and the Overleaf folder are inside Dropbox. Dropbox does not follow junctions (or symlinks on Windows) that point to other Dropbox folders — it would double-sync the same content. Writing directly to `$OverleafRoot/output/` is the reliable solution.

## One symlink IS needed: `[project-name]/tex/` → `[project-name]_Overleaf/`
AI agents (Claude Code, Codex) only read files inside the project's working directory. `$OverleafRoot` lives outside the project root, so without help the AI cannot see `.tex` files. The junction makes the Overleaf folder appear as a child of the project — the OS resolves it transparently. It's per-machine and excluded from Dropbox via `.dropboxignore`.

**Windows** (Command Prompt, no admin needed):
```
mklink /J "[path to ProjectX]\tex" "[path to ProjectX_Overleaf]"
```

**Mac** (Terminal):
```
ln -s "[path to ProjectX_Overleaf]" "[path to ProjectX]/tex"
```

## When reading `.tex` files
Use the project-relative `tex/` path (e.g., `tex/sections/01_introduction.tex`). Stata, R, and Python can use `$OverleafRoot` directly — but the AI cannot unless `$OverleafRoot` has been explicitly added to `additionalDirectories` in Claude Code settings.
