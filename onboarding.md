# Getting Started: Setup for New Co-authors and RAs

This guide covers the one-time setup and daily workflow for working on a project that uses AI coding agents (Claude Code and Codex) for AI-assisted research. Follow the steps in order.

---

## Step 0: Clone This Repo (one-time)

Clone this repository into your Dropbox folder so the files sync across your machines:

**Windows** (PowerShell 7):
```
cd "C:\Users\[you]\Dropbox\Work\Templates\AI"
git clone https://github.com/LorenzKueng/onboarding_collaborators.git
```
**Mac** (Terminal):
```
cd "$HOME/Dropbox/Work/Templates/AI"
git clone https://github.com/LorenzKueng/onboarding_collaborators.git
```

In all commands in Step 4, `[repo]` means the full path to this cloned folder:
- Windows: `C:\Users\[you]\Dropbox\Work\Templates\AI\onboarding_collaborators`
- Mac: `$HOME/Dropbox/Work/Templates/AI/onboarding_collaborators`

---

## Step 1: Install the Software (one-time)

**PowerShell 7** — the modern Windows command line. Download from the Microsoft Store or [github.com/PowerShell/PowerShell/releases](https://github.com/PowerShell/PowerShell/releases). (Mac users: use Terminal — no extra install needed.)

**Windows Terminal** (Windows only, optional but recommended) — a nicer window for running PowerShell 7. Download from the Microsoft Store. Once installed, set PowerShell 7 as the default: open Windows Terminal → dropdown arrow next to `+` → Settings → "Default profile" → select "PowerShell" (not "Windows PowerShell") → Save.

**VS Code** — a text editor for code (do-files, R, Python). Download from [code.visualstudio.com](https://code.visualstudio.com). After installing, open VS Code → View → Extensions → search "Claude Code" → Install.

**Node.js** — required by both AI agents. Install with:
```
winget install OpenJS.NodeJS.LTS
```

**Claude Code CLI** — the primary AI assistant. Install and log in:
```
npm install -g @anthropic-ai/claude-code
claude
```
Follow the prompts to authenticate with your Anthropic account.

**Codex CLI** — OpenAI's coding agent, used alongside Claude for execution-heavy tasks:
```
npm install -g @openai/codex
codex
```
Sign in with your ChatGPT account or an OpenAI API key.

---

## Step 2: Configure Git (one-time)

The project files arrive on your machine via Dropbox automatically — no cloning needed. But you do need to tell Git who you are so your commits are attributed correctly. Run these two commands once in PowerShell 7:
```
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

---

## Step 3: Understand the Project Structure

Open the project folder. The key files are:

| File / Folder | What it is |
|---------------|-----------|
| `CLAUDE.md` | Project instructions for Claude — read this first |
| `AGENTS.md` | Same instructions formatted for Codex |
| `MEMORY.md` | Current project status: what's done, what's next |
| `code/stata/00_setup.do` | All path globals (`$raw`, `$derived`, `$output`) — run at top of every do-file |
| `code/stata/master.do` | Runs the full pipeline |
| `data/raw/` | Raw data — never modify these files |
| `data/_derived/` | Intermediate processed datasets |
| `output/` | Local figures, tables, and other output (`$output`) |
| `progress_logs/` | Session logs — one file per AI session |

Example of the directory tree of ProjectX:
```
ProjectX/
├── .dropboxignore                      ← tells Dropbox not to sync per-machine files (tex symlink, AI state, scratch)
├── .gitignore                          ← tells Git to ignore data files (too large) and output (reproduced)
├── AGENTS.md                           ← project instructions for Codex
├── CLAUDE.md                           ← project instructions for Claude Code
├── MEMORY.md                           ← current status snapshot for AI agents and co-authors
├── README.md                           ← GitHub-facing overview (displayed on repo landing page)
├── REPLICATION.md                      ← replication instructions for journal data editor
├── _Tasks_for_the_AI.md                ← task list and background context for AI assistants
├── code/                               ← cloud sync + Git
│   ├── stata/                          ← interactive human + AI work on code before automation
│   │   ├── master.do                   ← run this to execute full pipeline
│   │   ├── 00_setup.do                 ← all globals; run at top of every do-file
│   │   └── ...
│   ├── R/                              ← R scripts (cross-language replication + full automation)
│   └── python/                         ← Python scripts (cross-language replication + full automation)
├── data/
│   ├── raw/                            ← $raw — read-only by convention; synced, not Git
│   │   ├── SCF/                        ← one subfolder for each main data source
│   │   │   ├── _source.md              ← where and when data was downloaded/acquired
│   │   │   └── documentation/
│   │   │       └── SCF_codebook.txt    ← codebooks and reference docs (excluded from git)
│   │   └── other_data/                 ← auxiliary data (e.g. CPI.csv to deflate)
│   └── _derived/                       ← $derived — intermediate processed datasets
│       └── SCF/                        ← example; rename to match your dataset
├── tex/                                ← symlink → ProjectX_Overleaf/ (set up manually; per-machine, not synced)
├── documents/                          ← literature (can use pandoc, ocrmypdf, marker or Cunningham's /split-pdf)
├── correspondence/
│   └── referee2/                       ← AI-generated referee feedback
├── progress_logs/                      ← session logs for continuity across AI conversations
│   └── YYYY-MM-DD_description.md       ← summarizes each AI session ('lab notebook')
└── _scratch/                           ← temporary files, not for sharing

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

Figures and tables are written directly to `ProjectX_Overleaf/output/figures/` and `ProjectX_Overleaf/output/tables/` (a real Dropbox folder that syncs to Overleaf cloud). No symlink or junction is needed for `output/`. See also the [Overleaf workflow skill](skills/overleaf_workflow/SKILL.md) for more detail.

---

## Step 4: Set Up Your Personal AI Tool Files (one-time per machine)

These are personal files that stay on your machine — not shared with co-authors. All setups below use **symbolic links** (invisible shortcuts) so the real files live in Dropbox (inside your clone of this repo) and sync automatically across your machines.

**Windows note:** `mklink /J` (junction) and `mklink` (file symlink) do **not** require admin. Run them in a normal Command Prompt. If a command fails with "access denied", try an elevated prompt (search "Command Prompt" → right-click → "Run as administrator"). Replace `[you]` with your Windows username and `[repo]` with the full path to your clone of this repo.

---

### 4a: Global instruction files — CLAUDE.md and AGENTS.md

**What they are:** Personal standing instructions to each agent — your role, communication preferences, tools you use, standing rules. Both agents read these at the start of every conversation, for every project.

Edit `[repo]/globals/CLAUDE_global.md` and `[repo]/globals/AGENTS_global.md` to reflect your own preferences, then create symlinks:

**Windows:**
```
mklink "C:\Users\[you]\.claude\CLAUDE.md" "[repo]\globals\CLAUDE_global.md"
mklink "C:\Users\[you]\.codex\AGENTS.md" "[repo]\globals\AGENTS_global.md"
```
**Mac:**
```
ln -s "[repo]/globals/CLAUDE_global.md" "$HOME/.claude/CLAUDE.md"
ln -s "[repo]/globals/AGENTS_global.md" "$HOME/.codex/AGENTS.md"
```

---

### 4b: Claude skills — reusable workflows

**What they are:** Skills are reusable multi-step workflows you invoke with a `/command`. Key ones: `/resume_session` (briefing at session start) and `/progress_log` (session summary at end). Skills live in `[repo]/skills/` and need a symlink so Claude can find them globally.

**Windows:**
```
mklink /J "C:\Users\[you]\.claude\skills" "[repo]\skills"
```
**Mac:**
```
ln -s "[repo]/skills" "$HOME/.claude/skills"
```

---

### 4c: Claude memory — persistent context across machines

**What it is:** Claude stores facts about you and the project in a memory folder. Without a symlink, this folder lives outside Dropbox and doesn't sync — Claude on your work desktop would have no memory of sessions on your laptop.

**Windows:**
```
mklink /J "C:\Users\[you]\.claude\projects\C--Users-[you]-Dropbox-Work-Templates-AI-onboarding_collaborators\memory" "[repo]\.claude\memory"
```
**Mac:**
```
ln -s "[repo]/.claude/memory" "$HOME/.claude/projects/[hashed-path]/memory"
```
(Replace `[you]` with your Windows username. On Mac, ask Claude for the exact hashed path: "where is my memory folder for this project?")

---

### 4d: Claude Code settings — status line and preferences

Two files in `[repo]/globals/` configure how Claude Code behaves. Symlink both so changes sync automatically across your machines:

**Windows:**
```
mklink "C:\Users\[you]\.claude\settings.json" "[repo]\globals\claude_settings.json"
mklink "C:\Users\[you]\.claude\statusline-command.sh" "[repo]\globals\statusline-command.sh"
```
**Mac:**
```
ln -s "[repo]/globals/claude_settings.json" "$HOME/.claude/settings.json"
ln -s "[repo]/globals/statusline-command.sh" "$HOME/.claude/statusline-command.sh"
```

Once both are in place, every Claude Code session will show a status bar:
```
Sonnet 4.6 | Context: 42% used | Session: 98% used (resets 19:00)
```
The script requires Python (already installed if you use Stata + R workflows).

> **Want per-machine customization?** Delete a symlink and replace it with a plain copy. Changes to that copy won't sync to other machines — useful if you want different voice or theme settings per machine.

---

### 4e: Overleaf setup — per project, once per machine

**Figures and tables — no junction needed.** Stata, R, and Python write output directly to `$OverleafRoot/output/figures/` and `$OverleafRoot/output/tables/` (globals set in `00_setup.do`). Dropbox syncs that real folder to Overleaf cloud. The folders are created automatically on the first run of `master.do`.

> Dropbox does not follow junctions or symlinks that point to other Dropbox folders — it would double-sync. Writing directly to `$OverleafRoot/output/` is the correct approach.

**Reading `.tex` files — one junction IS needed.** AI agents only read files inside the project's working directory. `$OverleafRoot` lives outside the project root, so the AI cannot see `.tex` files without help. A junction makes the Overleaf folder appear as a child of the project.

Create it once per machine, per project (no admin needed):

**Windows:**
```
mklink /J "[path to ProjectX]\tex" "[path to ProjectX_Overleaf]"
```
**Mac:**
```
ln -s "[path to ProjectX_Overleaf]" "[path to ProjectX]/tex"
```

The `tex/` entry in `.dropboxignore` prevents Dropbox from syncing this per-machine junction to co-authors. See `SETUP.md` in the project root for full details.

---

### 4f: user_profile.md — facts about you

Stores background facts that help Claude calibrate how it explains things (your role, skill level, tools you use). Claude uses this automatically.

Copy `[repo]/documents/user_profile.md` and edit it to reflect your background. Save it to:
```
C:\Users\[you]\.claude\projects\[hashed-path]\memory\user_profile.md
```
The easiest way to find the right folder: open Claude Code in the project directory and ask: "where is my user_profile.md for this project?" Claude will give you the exact path.

---

## Step 5: Daily Workflow

### When to use Claude Code vs. Codex

Both agents use the same project files (`CLAUDE.md`/`AGENTS.md`, `MEMORY.md`, `progress_logs/`). The difference is in how you work:

| Task | Use |
|------|-----|
| Understanding a project, planning, discussing tradeoffs | **Claude Code** |
| Debugging interactively, explaining code in plain English | **Claude Code** |
| Execution-heavy tasks: many edits, long autonomous runs | **Codex** |
| Terminal-heavy repeated edit/run/fix loops | **Codex** |

A common pattern: use Claude to plan and define the task, then hand off to Codex to execute.

---

### Starting a session

Open PowerShell 7 (or the terminal in VS Code), navigate to the project folder, and start your agent:
```
cd "C:\Users\[you]\Dropbox\Research\ProjectX"
claude
```
or
```
cd "C:\Users\[you]\Dropbox\Research\ProjectX"
codex
```

**Claude:** Run the skill:
```
/resume_session
```
Claude reads the latest progress log and `MEMORY.md` and gives you a briefing on where you left off.

**Codex:** Ask manually:
> "Read `AGENTS.md` and `MEMORY.md` and tell me where we left off."

---

### Working with the agent

A good prompt has three parts: **what you want**, **which files or variables**, and **any constraints**:

> "Using `$derived/SCF_clean.dta`, run a regression of log income on age and education. Stata only. Save the output table to `$output/tables/`."

A few rules of thumb:
- For any task that touches multiple files or has irreversible steps, start with: *"Tell me your plan first."* The agent will describe every step before doing anything — you can catch mistakes before they happen.
- Paste error messages directly into the chat — the agent can't see your screen.
- Standing instructions (tools you use, formatting preferences) belong in your global `CLAUDE.md` / `AGENTS.md` so you don't repeat them every time.

---

### Running Stata

Agents can't open Stata interactively. The standard workflow:
1. The agent writes the do-file
2. You run it in Stata
3. Paste any errors back into the chat

For automated runs, Claude can run Stata silently via the command line and read the log file itself.

---

### Checking the agent's work

Don't trust output you haven't checked, especially numbers:
- After data cleaning, ask the agent to show `summarize` output — check that means, min/max, and N look plausible
- Read any do-file the agent writes before running it — does it touch the right variables? Save to the right place?
- Agents sometimes invent variable names that don't exist in your data — running the code catches it, scanning first saves time
- Cross-language replication (Stata results replicated in R and Python) is the gold standard for catching errors

---

### Ending a session

**Claude:** Run the skill:
```
/progress_log
```
Claude writes a dated progress log to `progress_logs/`, updates `MEMORY.md`, commits, and pushes — all in one step.

**Codex:** Ask manually:
> "Write a progress log for today's session to `progress_logs/YYYY-MM-DD_description.md` and update `MEMORY.md`."

The log captures what was done, decisions made, and what's next. It feeds into `MEMORY.md` so future sessions and co-authors can pick up where you left off.

---

## Step 6: Git — Saving Your Work

Git tracks changes to code files. Run these commands at natural milestones (e.g., after finishing a data cleaning step):

```
git add .
git commit -m "short description of what you did"
git push
```

Either agent can run all of these for you — just ask: *"Commit my changes with the message 'finished income deflation'"*.

**What Git does and doesn't track:**
- Tracks: all code files (`.do`, `.R`, `.py`, `.md`)
- Does not track: data files (`.dta`, `.csv`, `.xlsx`) — those sync via Dropbox

---

## Quick Reference

| Task | How |
|------|-----|
| Start Claude session | `cd [project folder]` → `claude` → `/resume_session` |
| Start Codex session | `cd [project folder]` → `codex` → "Read AGENTS.md and MEMORY.md and tell me where we left off" |
| Plan before acting | "Tell me your plan first" |
| End Claude session | `/progress_log` |
| End Codex session | "Write a progress log to progress_logs/YYYY-MM-DD_description.md and update MEMORY.md" |
| Save code to Git | `git add .` → `git commit -m "description"` → `git push` |
| Long session getting confused | Type `/compact` in Claude to compress conversation history |
| When to use Claude | Planning, debugging, explanation, interactive work |
| When to use Codex | Execution-heavy tasks, long autonomous runs, many file edits |
