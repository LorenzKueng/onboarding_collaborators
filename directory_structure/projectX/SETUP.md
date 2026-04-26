# First-Time Project Setup (each co-author, once per machine)

This file describes the per-machine setup needed for any member of this research project. It's referenced from project-level `CLAUDE.md` / `AGENTS.md` so those files stay short.

## 1. Set your paths in `code/stata/00_setup.do`
Add a block for your username with your `$ProjectRoot` path and `$OverleafRoot` path. Stata, R, and Python use these globals to read inputs and write output. Both paths typically live inside Dropbox (e.g. `Dropbox/Research/ProjectX/` and `Dropbox/Apps/ShareLaTeX/ProjectX_Overleaf/`).

## 2. Overleaf output setup — no junction needed for `output/`
Figures and tables are written directly by Stata (or R/Python) to `$OverleafRoot/output/figures/` and `$OverleafRoot/output/tables/` — the globals are set in `00_setup.do`. Dropbox syncs that real folder to Overleaf cloud automatically.

The `capture mkdir` commands in `00_setup.do` create the folders on first run.

> **Why not use a junction here?** Both the project folder and the Overleaf folder are inside Dropbox. Dropbox does not follow junctions (or symlinks on Windows) that point to other Dropbox folders — it would double-sync the same content. Writing directly to `$OverleafRoot/output/` is the reliable solution.

## 3. One symlink IS needed for the AI: `tex/` → `[project-name]_Overleaf/`
This gives Claude and Codex read access to your `.tex` files via a project-relative path.

**Why this is needed.** AI agents (Claude Code, Codex) by default only read files inside the project's working directory. `$OverleafRoot` lives outside the project root (in `Dropbox/Apps/ShareLaTeX/`), so without help the AI cannot see `.tex` files. A junction makes the Overleaf folder appear *as a child of* the project — the OS resolves it transparently, so the AI accesses `.tex` files via `tex/...` (a path inside the project root) without you having to grant it access to the entire Overleaf folder.

Stata, R, and Python don't have this restriction — they use `$OverleafRoot` directly. The `tex/` junction is for the AI's benefit only.

The junction is per-machine and excluded from Dropbox via `.dropboxignore`, so each co-author creates their own.

**Windows** (Command Prompt, no admin required):
```
mklink /J "[path to ProjectX]\tex" "[path to ProjectX_Overleaf]"
```

**Mac** (Terminal):
```
ln -s "[path to ProjectX_Overleaf]" "[path to ProjectX]/tex"
```

For more detail on the Overleaf workflow, the AI can invoke the `/overleaf_workflow` skill.
