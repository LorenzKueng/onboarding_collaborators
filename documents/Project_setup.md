# Project Setup: Directory Structure, Overleaf, GitHub

---

## Setting Up a New Project: Directory Structure

Use the `/newproject_directory-structure [project-name]` skill to scaffold a new project instantly:
- Creates the full folder structure in the project directory
- Creates all template files (`.gitignore`, `CLAUDE.md`, `MEMORY.md`, `README.md`, `REPLICATION.md`, `00_setup.do`, `master.do`, progress log)
- Initializes Git

The skill is at `AI_tools/skills/newproject_directory-structure.md`.

Two cases depending on whether any of your data is sensitive.

---

### Case 1: All data is public (no secure server needed)

Two locations. Code, data, and output live in `ProjectX/`. The paper lives in `ProjectX_Overleaf/` — a separate folder (e.g. `Dropbox/Apps/ShareLaTeX/` for Overleaf's Dropbox sync). A `tex/` symlink inside `ProjectX/` gives Claude read access to the `.tex` files.

```
ProjectX/                               ← cloud sync + Git (all co-authors)
├── .dropboxignore                      ← tells Dropbox not to sync per-machine files (tex symlink, AI state, scratch)
├── .gitignore                          ← tells Git to ignore data files (too large) and output (reproduced)
├── AGENTS.md                           ← project instructions for Codex
├── CLAUDE.md                           ← project instructions + first-time setup
├── MEMORY.md                           ← current status snapshot for Claude and co-authors
├── README.md                           ← GitHub-facing overview (displayed on repo landing page)
├── REPLICATION.md                      ← replication instructions for journal data editor
├── _Tasks_for_the_AI.md               ← task list and background context for AI assistants
├── code/                               ← cloud sync + Git
│   ├── stata/                          ← interactive human + AI work on code before automation (AI prefers R + python)
│   │   ├── master.do                   ← run this to execute full pipeline
│   │   ├── 00_setup.do                 ← all globals; run at top of every do-file
│   │   └── ...
│   ├── R/                              ← R scripts (cross-language replication + full automation)
│   └── python/                         ← Python scripts (cross-language replication + full automation)
├── data/
│   ├── raw/                            ← $raw — read-only by convention (raw data never modified); synced, not Git
│   │   ├── SCF/
│   │   │   ├── _source.md             ← information about data, including where and when downloaded/acquired
│   │   │   └── documentation/
│   │   │       └── SCF_codebook.txt   ← codebooks and reference docs (excluded from git)
│   │   ├── IPUMS/
│   │   │   ├── _source.md
│   │   │   └── documentation/
│   │   │       └── IPUMS_codebook.pdf
│   │   └── other_data/                 ← auxiliary data (e.g. CPI.csv to deflate)
│   └── _derived/                       ← $derived — intermediate processed datasets (deleted before replication run)
│       └── SCF/                        ← example; rename to match your dataset
├── tex/                                ← symlink → ProjectX_Overleaf/ (set up manually; per-machine, not synced)
├── documents/                          ← literature (can use pandoc, ocrmypdf, marker or Cunningham's /split-pdf)
├── correspondence/
│   └── referee2/                       ← AI-generated referee feedback (see Scott Cunningham)
├── progress_logs/                      ← session logs for continuity across Claude conversations
│   └── YYYY-MM-DD_description.md       ← summarizes each AI session of each co-author ('lab notebook')
└── _scratch/                           ← temporary files, not for sharing (deleted before final replication run)

ProjectX_Overleaf/                      ← e.g. Dropbox/Apps/ShareLaTeX/ (synced to Overleaf cloud)
├── ProjectX.tex
├── ProjectX_slides.tex
├── sections/                           ← LaTeX section files
│   ├── 00_abstract.tex
│   └── 01_introduction.tex
└── output/                             ← REAL folder — $figures and $tables write here directly; Dropbox syncs to Overleaf
    ├── figures/
    ├── tables/
    └── other_output/               ← numbers and stats cited in the paper text (not in any figure or table)
```

**Globals in `00_setup.do`:**
```stata
global ProjectRoot   "C:/Users/[you]/Dropbox/Research/ProjectX"  // set per user
global OverleafRoot  "C:/Users/[you]/Dropbox/Apps/ShareLaTeX/ProjectX_Overleaf"  // set per user
global raw           "$ProjectRoot/data/raw"
global derived       "$ProjectRoot/data/_derived"
global figures       "$OverleafRoot/output/figures"
global tables        "$OverleafRoot/output/tables"
```

After running the skill, you still need to:
- Fill in `CLAUDE.md` (project description, co-authors)
- Add your username block to `00_setup.do` (both `$ProjectRoot` and `$OverleafRoot`)
- Create the `tex/` symlink (instructions in `CLAUDE.md`):
  - `ProjectX/tex/` → symlink pointing to `ProjectX_Overleaf/` (one-time per machine; excluded from Dropbox via `.dropboxignore`)

---

### Case 2: Some data is sensitive (secure server required)

Three locations. Code is developed locally with AI help, then pushed to the server. Output stays on the server until vetted by a third party, then pulled to the local project folder.

```
ProjectX/                               ← cloud sync + Git (all co-authors)
├── .gitignore                          ← tells Git to ignore data files and output
├── CLAUDE.md                           ← project instructions + first-time setup
├── MEMORY.md                           ← current status snapshot for Claude and co-authors
├── README.md                           ← GitHub-facing overview (displayed on repo landing page)
├── REPLICATION.md                      ← replication instructions for journal data editor
├── _Tasks_for_the_AI.md               ← task list and background context for AI assistants
├── code/
│   ├── stata/
│   │   ├── master.do                   ← run this to execute full pipeline
│   │   ├── 00_setup.do                 ← all globals; run at top of every do-file
│   │   ├── 01_public_clean.do
│   │   ├── 02_secure_clean.do          ← pushed to server to run there
│   │   └── 03_analysis.do
│   ├── R/                              ← R scripts (cross-language replication)
│   └── python/                         ← Python scripts (cross-language replication)
├── data/
│   ├── raw/                            ← $data_public — public data only; synced, not Git
│   │   ├── SCF/
│   │   │   ├── _source.md             ← where and when data was downloaded/acquired
│   │   │   └── documentation/
│   │   │       └── SCF_codebook.txt   ← codebooks and reference docs (excluded from git)
│   │   └── other_data/                 ← auxiliary data (e.g. CPI.csv to deflate)
│   └── _derived/                       ← intermediate files from public data only
│       └── SCF/                        ← example; rename to match your dataset
├── output/                             ← $output — flat, protected, Overleaf-facing
│   ├── figures/                           populated manually from server/output/vetted/
│   ├── tables/                            never written to by live code runs
│   └── other_output/
├── tex/                                ← symlink → ProjectX_Overleaf/ (set up manually; per-machine, not synced)
├── documents/                          ← literature (can use pandoc, ocrmypdf, marker or Cunningham's /split-pdf)
├── correspondence/
│   └── referee2/                       ← AI-generated referee feedback
├── progress_logs/
│   └── YYYY-MM-DD_description.md
└── _scratch/                           ← temporary files, not for sharing
    └── output/                         ← $output_dev — local dev runs write here

ProjectX_server/                        ← secure server (full-access co-authors only)
├── code/                               ← copy of ProjectX/code/ via rsync (one-way)
├── data/
│   ├── secure/                         ← $data_secure — never leaves server
│   │   └── _source.md                 ← where and when data was acquired
│   ├── public/                         ← copy of ProjectX/data/raw/ via rsync
│   └── _derived/                       ← all intermediate files (any that touched secure data)
├── output/
│   ├── secure/                         ← $output_secure — analysis output, awaiting vetting
│   └── vetted/                         ← third-party approved; rsync'd to ProjectX/output/
├── logs/
└── _scratch/                           ← temporary files on server

ProjectX_Overleaf/                      ← e.g. Dropbox/Apps/ShareLaTeX/ (synced to Overleaf cloud)
├── ProjectX.tex
├── ProjectX_slides.tex
├── sections/                           ← LaTeX section files
│   ├── 00_abstract.tex
│   └── 01_introduction.tex
└── output/                             ← REAL folder — vetted output is manually rsync'd here; Dropbox syncs to Overleaf
    ├── figures/
    ├── tables/
    └── other_output/               ← numbers and stats cited in the paper text (not in any figure or table)
```

**Output flow:**
```
server/output/secure/  → server/output/vetted/  → ProjectX/output/  → Overleaf
(code writes here)       (third-party approved)   (manual rsync;      (symlink)
                                                   flat, protected)
```
Local dev runs write to `$output_dev` (`_scratch/output/`) and never touch `$output` to avoid accidentally overwriting vetted results. For instance, we might want to simulate synthetic data in `ProjectX/` that mimics the structure of the sensitive data on `ProjectX_server/` to be able to develop the code first in `ProjectX/` with AI assistance before copying it to `ProjectX_server/`.

**Push code and public data to server** (run before any server job):
```bash
rsync -av "$ProjectX/code/"     user@server:ProjectX_server/code/
rsync -av "$ProjectX/data/raw/" user@server:ProjectX_server/data/public/
```

**Pull vetted output from server** (run after third-party approval):
```bash
rsync -av user@server:ProjectX_server/output/vetted/ "$ProjectX/output/"
```

**Globals in `00_setup.do`:**
```stata
* === Each user sets these ===
global ProjectX        "C:/Users/[you]/Dropbox/Research/ProjectX"
global ProjectX_server "/secure/ProjectX"           // omit if no server access

* === Public data (local) ===
global data_public     "$ProjectX/data/raw"
global derived_public  "$ProjectX/data/_derived"

* === Secure data (server) ===
global data_secure     "$ProjectX_server/data/secure"
global derived         "$ProjectX_server/data/_derived"

* === Output ===
global output          "$ProjectX/output"            // protected, Overleaf-facing
global output_dev      "$ProjectX/_scratch/output"   // dev runs only
global output_secure   "$ProjectX_server/output/secure"
```

Public-only co-authors omit `$ProjectX_server` and run only scripts using `$data_public`.

After running the skill, you still need to:
- Fill in `CLAUDE.md` (project description, co-authors, server paths)
- Add your username block to `00_setup.do` (both `$ProjectRoot` and `$OverleafRoot`)
- Create the `tex/` symlink (instructions in `CLAUDE.md`):
  - `ProjectX/tex/` → symlink pointing to `ProjectX_Overleaf/` (one-time per machine; excluded from Dropbox via `.dropboxignore`)

---

## Overleaf

Overleaf is an online LaTeX editor — like Google Docs, but for academic papers. Co-authors edit the `.tex` file and see a compiled PDF in real time. No local LaTeX installation needed.

The key integration with your workflow: figures and tables are written **directly** to `ProjectX_Overleaf/output/figures/` and `ProjectX_Overleaf/output/tables/` by the code (via the `$figures` and `$tables` globals in `00_setup.do`). This is a real folder that Dropbox syncs to Overleaf cloud. You just recompile in Overleaf and the paper reflects the latest results.

> **Why not use a junction?** Both the project folder and the Overleaf folder are inside Dropbox. Dropbox does not follow junctions (or symlinks on Windows) that point to other Dropbox folders — it would be double-syncing the same content. Writing directly to `$OverleafRoot/output/` is the reliable solution. No junction or symlink is needed for `output/`.

AI agents (Claude, Codex) are restricted to the project working directory and cannot access `$OverleafRoot` directly. The `tex/` junction makes the Overleaf folder appear as a child of the project root, giving agents access to `.tex` files — without it, agents cannot read the paper.

**The symlink + Dropbox problem — and how to solve it:**
The `tex/` symlink is per-machine (each co-author's path is different) but lives in a Dropbox-synced folder. If Dropbox syncs it, other co-authors receive a broken symlink. The fix is a **`.dropboxignore`** file in the project root — Dropbox respects it exactly like `.gitignore`:
```
# Per-machine symlinks — each co-author creates locally; do not sync
tex

# AI state files — machine-specific
.claude
.codex

# Temporary files
_scratch
```
Add this file to every project. The `tex/` entry prevents Dropbox from syncing the symlink.

**Telling Claude where the Overleaf folder lives:**
The Overleaf path differs per co-author (different usernames). Add an `OverleafRoot` global to `00_setup.do` alongside `ProjectRoot`:
```stata
if "`c(username)'" == "[your username]" {
    global ProjectRoot  "C:/Users/[you]/Dropbox/Research/ProjectX"
    global OverleafRoot "C:/Users/[you]/Dropbox/Apps/ShareLaTeX/ProjectX_Overleaf"
}
```
Claude reads `00_setup.do` at the start of every session **if instructed to do so in the local `CLAUDE.md`** (add a "Session Start" section: "At the start of each session, read `code/stata/00_setup.do` to know the current path globals"). Note: `$OverleafRoot` gives Stata/R/Python the Overleaf path, but Claude cannot access it directly — Claude is restricted to the project working directory. Claude reads `.tex` files via the `tex/` junction, which makes the Overleaf folder appear as a child of the project root.

**Tracking co-author edits:** Overleaf's built-in history (clock icon, top right) tracks every edit by every co-author, character by character, with user attribution — useful when co-authors forget to use review mode. This covers the version-control use case for `.tex` files without any extra setup.

**Git for .tex files:** Not needed for now. If you later want labeled commits ("draft sent to referee 1") or code and paper in one repo, use **Overleaf Pro's Git integration** — it exposes a Git remote you can add to your GitHub repo. Do not manually run Git inside `Dropbox/Apps/ShareLaTeX/` (Dropbox and Git writing to the same folder simultaneously can cause occasional conflicts).

---

## GitHub and GitHub Desktop

Three related but distinct things:

**GitHub** — a website (owned by Microsoft) that stores your code in the cloud. Not just backup — it adds version history with labeled snapshots, collaboration features, and is the standard platform for sharing research code.

**GitHub Desktop** — a visual app with buttons and menus for using GitHub without typing commands. Useful for committing, viewing history, and resolving merge conflicts with a co-author. Claude Code can also run these operations for you automatically from the terminal.

**Use both Dropbox and GitHub — they serve different purposes:**

| | Dropbox | GitHub |
|--|---------|--------|
| What to store | Data, documents, large files | Code only |
| Version history | Timestamps only | Labeled commits, full history |
| Co-author collaboration | File sync | Proper merge, code review |
| Replication packages | No | Yes — journal standard |

GitHub's version control is significantly better than Dropbox for code:
- **Labeled history** — find and restore the exact code that produced any result
- **Branching** — try experimental changes without touching working code; merge if it works, discard if not
- **Replicability** — tag the state of your code at submission ("AER submission March 2026"); anyone can restore it exactly. Most top journals now require this.
- **Agentic AI** — Claude Code works better inside git repos; tools like GitHub Copilot require it

GitHub is the standard in empirical economics, especially among researchers using agentic AI tools.

**`.gitignore` — tell GitHub what to ignore:**

GitHub tracks code only — not data. Large files (`.dta`, `.csv`, `.xlsx`) stay in Dropbox. A `.gitignore` file in your project root tells GitHub to skip them:

```
# Data files — tracked by Dropbox, not GitHub
*.dta
*.csv
*.xlsx
data/raw/
data/_derived/

# Output files — regenerated by code, not tracked
output/

# Scratch files
_scratch/

# Overleaf symlink — contents tracked by Overleaf, not GitHub
tex/
```

The `/newproject_directory-structure` skill creates this file automatically.

**How to learn it:** Don't take a full course. Use it on one project with Claude's help — Claude can tell you exactly what to do via GitHub Desktop, or run the underlying commands for you automatically.
