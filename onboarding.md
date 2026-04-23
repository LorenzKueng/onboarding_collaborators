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
| `output/` | Figures and tables (linked to Overleaf) |
| `progress_logs/` | Session logs — one file per AI session |

Example directory structure:
```
ProjectX/
├── .gitignore                          ← tells Git to ignore data files (too large) and output (reproduced)
├── CLAUDE.md                           ← project instructions for Claude Code
├── AGENTS.md                           ← project instructions for Codex (same content, different format)
├── MEMORY.md                           ← current status snapshot for AI agents and co-authors
├── README.md                           ← GitHub-facing overview (displayed on repo landing page)
├── REPLICATION.md                      ← replication instructions for journal data editor
├── code/                               ← cloud sync + Git
│   ├── stata/                          ← interactive human + AI work on code before automation
│   │   ├── master.do                   ← run this to execute full pipeline
│   │   ├── 00_setup.do                 ← all globals; run at top of every do-file
│   │   └── ...
│   ├── R/                              ← R scripts (cross-language replication + full automation)
│   └── python/                         ← Python scripts (cross-language replication + full automation)
├── data/
│   ├── raw/                            ← $raw — read-only by convention; synced, not Git
│   └── _derived/                       ← $derived — intermediate processed datasets
├── output/                             ← $output — symlinked from Overleaf
│   ├── figures/
│   ├── tables/
│   └── other_output/
├── tex/                                ← symlink → ProjectX_Overleaf/ (AI reads .tex files)
├── documents/                          ← literature
├── correspondence/
│   └── referee2/                       ← AI-generated referee feedback
├── progress_logs/                      ← session logs for continuity across AI conversations
│   └── YYYY-MM-DD_description.md       ← summarizes each AI session ('lab notebook')
└── _scratch/                           ← temporary files, not for sharing
```

A template for starting a new project is in `directory_structure/projectX/` in this repo.

---

## Step 4: Set Up Your Personal AI Tool Files (one-time per machine)

These are personal files that stay on your machine — not shared with co-authors. All setups below use **symbolic links** (invisible shortcuts) so the real files live in Dropbox (inside your clone of this repo) and sync automatically across your machines.

Run all `mklink` commands in **Command Prompt as Administrator** (search "Command Prompt" → right-click → "Run as administrator"). Replace `[you]` with your Windows username and `[repo]` with the full path to your clone of this repo.

---

### 4a: Global instruction files — CLAUDE.md and AGENTS.md

Personal standing instructions to each agent — your role, communication preferences, tools you use, standing rules. Both agents read these at the start of every conversation, for every project.

Edit `[repo]/CLAUDE_global.md` and `[repo]/AGENTS_global.md` to reflect your own preferences, then create symlinks:

**Windows:**
```
mklink "C:\Users\[you]\.claude\CLAUDE.md" "[repo]\CLAUDE_global.md"
mklink "C:\Users\[you]\.codex\AGENTS.md" "[repo]\AGENTS_global.md"
```
**Mac:**
```
ln -s "[repo]/CLAUDE_global.md" "$HOME/.claude/CLAUDE.md"
ln -s "[repo]/AGENTS_global.md" "$HOME/.codex/AGENTS.md"
```

---

### 4b: Claude skills — reusable workflows

Skills are reusable multi-step workflows you invoke with a `/command`. Key ones: `/resume_session` (briefing at session start) and `/progress_log` (session summary at end).

**Windows:**
```
mklink /D "C:\Users\[you]\.claude\skills" "[repo]\skills"
```
**Mac:**
```
ln -s "[repo]/skills" "$HOME/.claude/skills"
```

---

### 4c: Claude Code settings — status line and preferences

Two files configure how Claude Code behaves.

Copy `[repo]/claude_settings.json` to `C:\Users\[you]\.claude\settings.json` (Windows) or `~/.claude/settings.json` (Mac).

Copy `[repo]/statusline-command.sh` to `C:\Users\[you]\.claude\statusline-command.sh` (Windows) or `~/.claude/statusline-command.sh` (Mac).

Once both files are in place, every Claude Code session will show a status bar:
```
Sonnet 4.6 | Context: 42% used | Session: 98% used (resets 19:00)
```
The script requires Python (already installed if you use Stata + R workflows).

---

### 4d: user_profile.md — facts about you

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

Begin every session by telling the agent to read the project state:
> "Read `CLAUDE.md` (or `AGENTS.md`) and `MEMORY.md` and tell me where we left off."

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

Ask the agent to write a progress log:
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
| Start a session | `cd [project folder]` → `claude` or `codex` → "Read CLAUDE.md and MEMORY.md and tell me where we left off" |
| Plan before acting | "Tell me your plan first" |
| End a session | "Write a progress log to progress_logs/YYYY-MM-DD_description.md and update MEMORY.md" |
| Save code to Git | `git add .` → `git commit -m "description"` → `git push` |
| Long session getting confused | Type `/compact` in Claude to compress conversation history |
| When to use Claude | Planning, debugging, explanation, interactive work |
| When to use Codex | Execution-heavy tasks, long autonomous runs, many file edits |
