# Project Setup: Directory Structure, Overleaf, GitHub

> **These repos are reference-only — never put project files here.** `AI_tools/` and `onboarding_collaborators/` hold guides, skills, and templates *about* the workflow. Your actual research project lives in its **own folder** outside these repos (e.g. `~/Dropbox/Research/ProjectX/`, on Windows `C:\Users\YOU\Dropbox\Research\ProjectX\`).
>
> **To scaffold a new project**, open your AI assistant *inside the new empty project folder* and say:
> *"Read the `Project_setup.md` guide and create this directory structure here, in my new project folder (e.g. `~/Dropbox/Research/ProjectX/`). Use Case 1 (all data public) unless I say `--secure`."*
> The AI creates the folders and the template files below. There is no scaffolding skill — the structure is documented here so any AI can build it on demand.

**Contents:**

- [Setting Up a New Project: Directory Structure](#setting-up-a-new-project-directory-structure)
  - [Case 1: All data is public (no secure server needed)](#case-1-all-data-is-public-no-secure-server-needed)
  - [Case 2: Some data is sensitive (secure server required)](#case-2-some-data-is-sensitive-secure-server-required)
- [Template file contents](#template-file-contents)
- [Meeting transcripts (Teams / Fireflies)](#meeting-transcripts-teams--fireflies)
- [Overleaf](#overleaf)
- [GitHub and GitHub Desktop](#github-and-github-desktop)

---

## Setting Up a New Project: Directory Structure

To scaffold a new project, open your AI assistant **inside the new (empty) project folder** and tell it to read this guide and build the structure here — e.g. *"Read `Project_setup.md` and create this directory structure in my new project folder `~/Dropbox/Research/ProjectX/`."* The AI will:
- Create the full folder structure in the project directory
- Create all template files (`.gitignore`, `.dropboxignore`, `CLAUDE.md`, `AGENTS.md`, `MEMORY.md`, `README.md`, `REPLICATION.md`, `_Tasks_for_the_AI.md`, `00_setup.do`, `master.do`, a first progress log) — contents in [Template file contents](#template-file-contents) below
- Initialize Git (`git init`, first commit)

Two cases, depending on whether any of your data is sensitive.

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
├── _Tasks_for_the_AI.md                ← task list and background context for AI assistants
├── code/                               ← cloud sync + Git
│   ├── stata/                          ← interactive human + AI work on code before automation (AI prefers R + python)
│   │   ├── master.do                   ← run this to execute full pipeline
│   │   ├── 00_setup.do                 ← all globals; run at top of every do-file
│   │   └── ...
│   ├── R/                              ← R scripts (cross-language replication + full automation)
│   └── python/                         ← Python scripts (cross-language replication + full automation)
├── data/
│   ├── raw/                            ← $raw — read-only by convention (raw data never modified); synced, not Git
│   │   ├── SCF/                        ← one subfolder for each main data source (e.g., SCF, IPUMS)
│   │   │   ├── _source.md              ← information about data, including where and when downloaded/acquired
│   │   │   └── documentation/
│   │   │       └── SCF_codebook.txt    ← codebooks and reference docs (excluded from git)
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
│   ├── referee2/                       ← AI-generated referee feedback (see Scott Cunningham)
│   └── meeting_notes/                  ← meeting transcripts + AI summaries (raw transcripts git-ignored; see below)
│       ├── YYYY-MM-DD_coauthor-call_transcript.docx   ← raw export (MS Teams = .docx; Fireflies/Otter offer .md, .txt, .srt, ...)
│       └── YYYY-MM-DD_coauthor-call_summary.md        ← AI-generated summary (committed)
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
    └── other_output/                   ← numbers and stats cited in the paper text (not in any figure or table)
```

**Globals in `00_setup.do`:**
```stata
global ProjectRoot   "C:/Users/YOU/Dropbox/Research/ProjectX"  // set per user
global OverleafRoot  "C:/Users/YOU/Dropbox/Apps/ShareLaTeX/ProjectX_Overleaf"  // set per user
global raw           "$ProjectRoot/data/raw"
global derived       "$ProjectRoot/data/_derived"
global figures       "$OverleafRoot/output/figures"
global tables        "$OverleafRoot/output/tables"
```

After scaffolding, you still need to:
- Fill in `CLAUDE.md` (project description, co-authors)
- Add your username block to `00_setup.do` (both `$ProjectRoot` and `$OverleafRoot`)
- Create the `tex/` symlink (instructions in `CLAUDE.md`):
  - `ProjectX/tex/` → symlink pointing to `ProjectX_Overleaf/` (one-time per machine; excluded from Dropbox via `.dropboxignore`)

---

### Case 2: Some data is sensitive (secure server required)

Three locations. Code is developed locally with AI help, then pushed to the server. Output stays on the server until vetted by a third party, then pulled to the local project folder. Scaffold this variant by telling the AI *"...use Case 2 (`--secure`)."*

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
├── documents/                          ← literature (split with Scott's /split-pdf)
├── correspondence/
│   ├── referee2/                       ← AI-generated referee feedback
│   └── meeting_notes/                  ← meeting transcripts + AI summaries (raw transcripts git-ignored; see below)
│       ├── YYYY-MM-DD_coauthor-call_transcript.docx   ← raw export (MS Teams = .docx; Fireflies/Otter offer .md, .txt, .srt, ...)
│       └── YYYY-MM-DD_coauthor-call_summary.md        ← AI-generated summary (committed)
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
global ProjectX        "C:/Users/YOU/Dropbox/Research/ProjectX"
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

After scaffolding, you still need to:
- Fill in `CLAUDE.md` (project description, co-authors, server paths)
- Add your username block to `00_setup.do` (both `$ProjectRoot` and `$OverleafRoot`)
- Create the `tex/` symlink (instructions in `CLAUDE.md`):
  - `ProjectX/tex/` → symlink pointing to `ProjectX_Overleaf/` (one-time per machine; excluded from Dropbox via `.dropboxignore`)
- Full-access co-authors set up the server directory and `$ProjectX_server`; use `$output_dev` for all local runs (never write to `$output` directly)

---

## Template file contents

These are the starter contents the AI writes into the new project. `.gitignore` and `.dropboxignore` appear in the [GitHub](#github-and-github-desktop) and [Overleaf](#overleaf) sections; `00_setup.do` appears per-case above. The rest follow.

### `CLAUDE.md` (Case 1)

```markdown
# Project: [Project Name]

## What This Project Is
[One paragraph description of the research question]

## Key Files
- `code/stata/master.do` — run this to execute the full pipeline
- `code/stata/00_setup.do` — sets all path globals; sourced at top of every do-file

## Stata Globals
- `$raw` — raw data folder (`data/raw/`)
- `$derived` — intermediate processed datasets (`data/_derived/`)
- `$output` — figures, tables, and other output (written to `$OverleafRoot/output/`)
- `$OverleafRoot` — local path to Overleaf folder (set per user in `00_setup.do`; AI reads `.tex` via `tex/` symlink)

## Conventions
- Raw data is never modified — all processing in `_derived/`
- Every do-file starts by running `00_setup.do`
- Cross-language replication: Stata results replicated in R and Python

## Co-authors
[Names and roles if applicable]

## Session Start
At the start of each session, read `code/stata/00_setup.do` to know the current path globals.

## First-Time Setup (each co-author, once per machine)
1. Set your paths in `code/stata/00_setup.do` (a block for your username with `$ProjectRoot` and `$OverleafRoot`).
2. Create the `tex/` symlink (excluded from Dropbox via `.dropboxignore`):
   - Windows (Command Prompt, no admin): `mklink /J "[path to ProjectX]\tex" "[path to ProjectX_Overleaf]"`
   - Mac (Terminal): `ln -s "[path to ProjectX_Overleaf]" "[path to ProjectX]/tex"`
   - No symlink is needed for `output/` — code writes to `$OverleafRoot/output/` directly.
```

For **Case 2 (`--secure`)**, `CLAUDE.md` additionally documents the secure-data globals (`$data_public`, `$data_secure`, `$derived`, `$output_dev`, `$output_secure`), the server directory, and the rsync push/pull steps shown in Case 2 above.

### `AGENTS.md`
Codex equivalent of `CLAUDE.md` — create it with **identical content**. Codex reads it automatically at the start of every session.

### `MEMORY.md`

```markdown
# Project Memory — [Project Name]

## Status
- **Done:**
- **In progress:**
- **Next:**

## Key Decisions
-

## Known Issues / Quirks
-

## People
-
```

### `README.md` (GitHub-facing)

```markdown
# [Project Name]

[One paragraph description of the research question]

## Key Files
- `code/stata/master.do` — run this to reproduce all results from scratch
- `REPLICATION.md` — replication instructions for the journal data editor
- `CLAUDE.md` — project instructions and first-time setup for co-authors (Claude)
- `AGENTS.md` — project instructions for co-authors using Codex
- `MEMORY.md` — index of persistent AI memory for this project
- `_Tasks_for_the_AI.md` — task list and background context for AI assistants
- `.gitignore` / `.dropboxignore` — exclude data, output, and per-machine files

## Co-authors
[Names and roles if applicable]
```

### `REPLICATION.md`

```markdown
# [Project Name] — Replication Package

## Overview
[Brief description of the paper]

## Requirements
- Stata [version]
- R [version]
- Python [version]

## Data Sources
- [Dataset 1]: see `data/raw/_source.md`

## How to Replicate
Run `code/stata/master.do`.
```

### `master.do`

```stata
********************************************************************************
*** MASTER DO-FILE — [Project Name]
********************************************************************************

if "`c(username)'" == "[your username]" {
    cd "[path to project]/code/stata"
}

do "00_setup.do"
* do "[next do-file].do"
```

### `_Tasks_for_the_AI.md`
A running task list and background context for AI assistants (open TODOs, decisions, scoping notes). This is where `/meeting_notes` appends extracted action items.

---

## Meeting transcripts (Teams / Fireflies)

Meeting recordings (MS Teams, Fireflies, etc.) are treated like inbound correspondence: keep the raw transcript, then have AI distill it into a summary plus next steps that feed your existing task sinks.

**Where they go:** `correspondence/meeting_notes/`. Store the raw transcript and the AI summary side by side, dated:
- `correspondence/meeting_notes/YYYY-MM-DD_coauthor-call_transcript.docx` — raw export from the meeting app
- `correspondence/meeting_notes/YYYY-MM-DD_coauthor-call_summary.md` — AI-generated summary

**File formats differ by app:** MS Teams exports transcripts as **`.docx`**; Fireflies, Otter, and Zoom offer several formats (`.md`, `.txt`, `.srt`, `.vtt`, `.docx`). Keep the `_transcript.` infix in the filename whatever the extension — the `.gitignore` rule matches on it. Note that `.docx` is not plain text (it is zipped XML), so the AI converts it to text/markdown first (e.g. with `pandoc`) before reading; `.md`/`.txt` exports are read directly.

**What gets committed:** the **summary** (the durable, distilled artifact). Raw transcripts are large, noisy, and may contain offhand remarks, so they are **git-ignored** (the cloud copy in the meeting app is the backup). The `.gitignore` line is `correspondence/meeting_notes/*_transcript.*` (matches any extension). Transcripts still sync via Dropbox so co-authors and AI can read them; they just stay out of version history.

**How to process them:** invoke the **`/meeting_notes`** skill (or tell your AI: *"summarize `correspondence/meeting_notes/<file>_transcript.txt`"*). It reads the raw transcript and produces a fixed-shape summary — 3-5 sentence overview, decisions, numbered action items with owners, open questions. It **shows you the extracted action items first**; on your OK it appends them to `_Tasks_for_the_AI.md` and drops a one-line pointer in the current progress log. (Show-then-append is deliberate: transcript extraction can invent a "next step" nobody agreed to.)

---

## Overleaf

Overleaf is an online LaTeX editor — like Google Docs, but for academic papers. Co-authors edit the `.tex` file and see a compiled PDF in real time. No local LaTeX installation needed.

The key integration with your workflow: figures and tables are written **directly** to `ProjectX_Overleaf/output/figures/` and `ProjectX_Overleaf/output/tables/` by the code (via the `$figures` and `$tables` globals in `00_setup.do`). This is a real folder that Dropbox syncs to Overleaf cloud. You just recompile in Overleaf and the paper reflects the latest results.

> **Why not use a junction?** Both the project folder and the Overleaf folder are inside Dropbox. Dropbox does not follow junctions (or symlinks on Windows) that point to other Dropbox folders — it would be double-syncing the same content. Writing directly to `$OverleafRoot/output/` is the reliable solution. No junction or symlink is needed for `output/`.

One symlink, `ProjectX/tex/`, points to the Overleaf folder (`Dropbox/Apps/ShareLaTeX/ProjectX_Overleaf/`). This gives Claude a short path to read `.tex` files when working in the project directory.

**The symlink + Dropbox problem — and how to solve it:**
The `tex/` symlink is per-machine (each co-author's path is different) but lives in a Dropbox-synced folder. If Dropbox syncs it, other co-authors receive a broken symlink. The fix is a **`.dropboxignore`** file in the project root — Dropbox respects it exactly like `.gitignore`:
```
# Per-machine symlinks — each co-author creates locally; do not sync
tex

# AI state files — machine-specific (but DO sync memory)
.claude
!.claude/memory
.codex
!.codex/memories

# Temporary files
_scratch
```
Add this file to every project. The `tex/` entry prevents Dropbox from syncing the symlink.

**Telling Claude where the Overleaf folder lives:**
The Overleaf path differs per co-author (different usernames). Add an `OverleafRoot` global to `00_setup.do` alongside `ProjectRoot`:
```stata
if "`c(username)'" == "Kueng" {
    global ProjectRoot  "C:/Users/Kueng/Dropbox/Research/ProjectX"
    global OverleafRoot "C:/Users/Kueng/Dropbox/Apps/ShareLaTeX/ProjectX_Overleaf"
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

# Raw meeting transcripts — keep the summary, not the transcript
correspondence/meeting_notes/*_transcript.*

# Scratch files
_scratch/

# Overleaf symlink — contents tracked by Overleaf, not GitHub
tex/

# Editor state (machine-specific)
.vscode/

# Git worktrees — per-user parallel checkouts; do not commit
worktrees/
```

The AI writes this file when it scaffolds the project.

**Why `worktrees/` is excluded:** because the project root is in shared Dropbox, only one branch can be checked out at a time — if a co-author switches branches, everyone's working directory switches with them. Co-authors who want to run **parallel AI sessions** (e.g., two Claude Code windows on different branches) can create a personal git *worktree* under `worktrees/` and work there on their own branch without disrupting anyone else. The folder is per-user and ignored by Git.

**Common Git / GitHub terminology (plain English):**

| Term | What it means |
|------|---------------|
| **Repository** (or **repo**) | A project folder tracked by Git. On GitHub, it lives at `github.com/<owner>/<name>`. |
| **Clone** | The first-time download of an entire repo, with its full history (`git clone <url>`). One-time per machine — creates a new local copy. |
| **Pull** | Update an existing local clone with the latest commits from GitHub (`git pull`). Routine — do this when a co-author has pushed changes. |
| **Push** | Upload your local commits to GitHub (`git push`). The opposite of pull. |
| **Tracked / untracked** | A *tracked* file is one Git is following. An *untracked* file is new — Git sees it but isn't following it yet. `git status` lists untracked files separately so you can decide whether to add them. |
| **Staged** | A change you've marked for the next commit (via `git add <file>`). Think of the "staging area" as a tray: you load the changes you want to save together onto the tray (`git add`), then `git commit` serves the whole tray as one labeled snapshot. Changes still in your working files but not on the tray are "not staged" and will be left out of the next commit. This lets you bundle related changes into one commit while leaving unrelated edits for a separate commit later. |
| **Commit** | A labeled snapshot of your *staged* changes (`git commit -m "fix clustering"`). Local until you push. |
| **Branch** | A parallel line of development (e.g. `main` for the working version, `experiment-X` for a side track). Merge it back into `main` when ready. |
| **Merge** | Combine two branches. `git merge` or, on GitHub, "merge a pull request". |
| **Pull request** (or **PR**) | A proposal to merge one branch into another, opened on GitHub. Co-authors review and approve before the merge. |
| **Fork** | Your own copy of someone else's repo on GitHub. Common for contributing to open-source projects you don't own. |
| **Download** | Generic term — sometimes means "clone the whole repo", sometimes "grab a single file" (e.g. raw `README.md` via the GitHub web interface). When in doubt, ask which is meant. |

The shortest mental model: **clone once; pull regularly; commit your work; push to share.**

**How to learn it:** Don't take a full course. Use it on one project with Claude's help — Claude can tell you exactly what to do via GitHub Desktop, or run the underlying commands for you automatically.
