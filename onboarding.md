# Getting Started: Setup for New Co-authors and RAs

This guide covers the one-time setup and daily workflow for working on a project that uses AI coding agents (Claude Code and Codex) for AI-assisted research. Follow the steps in order.

**Contents:**
- [Step 0: Clone This Repo](#step-0-clone-this-repo-one-time)
- [Step 1: Install the Software](#step-1-install-the-software-one-time)
- [Step 2: Configure Git](#step-2-configure-git-one-time)
- [Step 3: Authenticate with GitHub](#step-3-authenticate-with-github-one-time)
- [Step 4: Understand the Project Structure](#step-4-understand-the-project-structure)
- [Step 5: Set Up Your Personal AI Tool Files](#step-5-set-up-your-personal-ai-tool-files-one-time-per-machine)
- [Step 6: Daily Workflow](#step-6-daily-workflow)
- [Step 7: Git — Saving Your Work](#step-7-git--saving-your-work)
- [Quick Reference](#quick-reference)

---

## Step 0: Clone This Repo (one-time)

Clone this repository into any folder inside your Dropbox so the files sync across your machines. Pick a location that makes sense to you — for example, a dedicated `AI_tools` folder. Do **not** put it inside an existing research project folder.

**Windows** (PowerShell 7):
```
cd "C:\Users\[you]\Dropbox\AI_tools"
git clone https://github.com/LorenzKueng/onboarding_collaborators.git
```
**Mac** (Terminal):
```
cd "$HOME/Dropbox/AI_tools"
git clone https://github.com/LorenzKueng/onboarding_collaborators.git
```

In all commands in Step 5, `[repo]` means the full path to this cloned folder:
- Windows: `C:\Users\[you]\Dropbox\AI_tools\onboarding_collaborators`
- Mac: `$HOME/Dropbox/AI_tools/onboarding_collaborators`

(If you chose a different parent folder, substitute it everywhere `[repo]` appears.)

---

## Step 1: Install the Software (one-time)

### Windows Users Only

**PowerShell 7** — the modern Windows command line. Download from the Microsoft Store or [github.com/PowerShell/PowerShell/releases](https://github.com/PowerShell/PowerShell/releases).

**Windows Terminal** (optional but recommended) — a nicer window for running PowerShell 7. Download from the Microsoft Store. Once installed, set PowerShell 7 as the default: open Windows Terminal → dropdown arrow next to `+` → Settings → "Default profile" → select "PowerShell" (not "Windows PowerShell") → Save.

### Mac Users Only

**Homebrew** — Mac's package manager, needed to install software from the command line:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Both Windows and Mac Users

**VS Code** (Visual Studio Code) — a text editor for code (do-files, R, Python). Download from [code.visualstudio.com](https://code.visualstudio.com). After installing, install the following extensions (View → Extensions → search by name → Install):

| Extension | Purpose | Required? |
|-----------|---------|-----------|
| Claude Code | Claude AI assistant inside VS Code | Yes |
| Codex – OpenAI's coding agent | Codex AI assistant inside VS Code | Yes |
| GitHub Pull Requests | Review and merge pull requests without leaving VS Code | Yes |
| Stata Workbench | Run do-files directly from VS Code; lets AI agents interact with Stata via MCP (Model Context Protocol — a standard that lets AI agents control other software — requires Stata 17+) | Yes |
| R | R language support (install this; others come with it) | Yes |
| Python | Python language support; auto-installs Pylance and Python Debugger | Yes |
| R Syntax | Enhanced R syntax highlighting | Optional |
| Python Environments | Manage virtual/conda environments inside VS Code | Optional |
| GitLens | Inline Git blame and history — see who changed what line and when | Optional |

**Git** — version control system used to save and share code.

Windows:
```
winget install Git.Git
```
Mac: pre-installed. Verify with `git --version`; if missing, run
```
brew install git
```

**GitHub CLI** (Command-Line Interface — a program you run by typing commands in a terminal) — lets Git connect to GitHub using your browser login, so you never need to manage access tokens (single-use passwords that expire) manually.

Windows:
```
winget install GitHub.cli
```
Mac:
```
brew install gh
```

**Node.js** — the software platform that Claude Code and Codex are built on; must be installed for them to run.

Windows:
```
winget install OpenJS.NodeJS.LTS
```
Mac:
```
brew install node
```

**Claude Code** — Anthropic's AI coding assistant. Install and log in (same command on Windows and Mac; `-g` installs it system-wide):
```
npm install -g @anthropic-ai/claude-code
claude
```
Follow the prompts to authenticate with your Anthropic account.

**Codex** — OpenAI's coding agent, used alongside Claude for execution-heavy tasks (same command on Windows and Mac):
```
npm install -g @openai/codex
codex
```
Sign in with your ChatGPT account or an OpenAI API key (a private password-like code that lets software access OpenAI's services).

---

> **Git glossary** (plain English):
> - **Repository (repo)** — the shared project folder tracked by Git; lives on GitHub and on each collaborator's machine.
> - **Commit** — a saved snapshot of your changes, with a short message describing what you did. Like "Save As" but permanent and reversible.
> - **Push** — upload your commits from your machine to GitHub so others can see them.
> - **Pull** — download commits others have pushed to GitHub onto your machine.
> - **Branch** — a parallel version of the project you can work on without affecting the main version. We usually work on `main`.
> - **Clone** — download a full copy of a repository from GitHub to your machine for the first time.

## Step 2: Configure Git (one-time)

The project files arrive on your machine via Dropbox automatically — no cloning needed. But you do need to tell Git who you are so your commits are attributed correctly. Run these two commands once in PowerShell 7 (Windows) or Terminal (Mac):
```
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

---

## Step 3: Authenticate with GitHub (one-time)

Git needs permission to push to the private project repository. The easiest way is the **GitHub CLI**.

**Windows** (PowerShell 7) and **Mac** (Terminal):
```
gh auth login
```

Follow the prompts: choose GitHub.com → HTTPS → log in via browser. After that, `git push` and `git pull` work automatically in both Terminal and VS Code.

> You'll need a GitHub account. If you don't have one, create it free at [github.com](https://github.com). Then ask Lorenz to add you as a collaborator on the project repository.

---

> **For project creator (e.g., Lorenz):** Before collaborators can push, add them to the GitHub repo:
> 1. Go to the repo on GitHub (e.g. `github.com/LorenzKueng/onboarding_project`)
> 2. **Settings → Collaborators → Add people**
> 3. Enter each collaborator's GitHub username or email → **Add**
> 4. They accept the invitation via email — they cannot push until they do

---

## Step 4: Understand the Project Structure

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
├── .dropboxignore                      ← tells Dropbox not to sync per-machine files (tex shortcut, AI memory files, scratch)
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
│   ├── R/                              ← R scripts (code files; cross-language replication + full automation)
│   └── python/                         ← Python scripts (code files; cross-language replication + full automation)
├── data/
│   ├── raw/                            ← $raw — read-only by convention; synced, not Git
│   │   ├── SCF/                        ← one subfolder for each main data source
│   │   │   ├── _source.md              ← where and when data was downloaded/acquired
│   │   │   └── documentation/
│   │   │       └── SCF_codebook.txt    ← codebooks and reference docs (excluded from git)
│   │   └── other_data/                 ← auxiliary data (e.g. CPI.csv to deflate)
│   └── _derived/                       ← $derived — intermediate processed datasets
│       └── SCF/                        ← example; rename to match your dataset
├── output/
│   ├── figures/
│   ├── tables/
│   └── other_output/
├── tex/                                ← shortcut → ProjectX_Overleaf/ (set up manually; per-machine, not synced)
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

## Step 5: Set Up Your Personal AI Tool Files (one-time per machine)

These are personal files that stay on your machine — not shared with co-authors. All setups below use **invisible shortcuts** so the real files live in Dropbox and sync automatically across machines. On Mac, these are called **symlinks** (`ln -s`). On Windows, folder shortcuts are called **junctions** (`mklink /J`) and file shortcuts are called **symlinks** (`mklink`) — both work without admin rights.

In the commands below, replace:
- `[you]` with your username (e.g. `Kueng` on Windows, your home folder name on Mac)
- `[repo]` with the full path to your clone of this repo (defined in Step 0)
- `[hashed-path]` with the path Claude uses internally for your project — ask Claude: "where is my memory folder for this project?"

**Windows note:** Run `mklink` commands in Command Prompt, not PowerShell — `mklink` is not available in PowerShell. If a command fails with "access denied", try an elevated prompt (search "Command Prompt" → right-click → "Run as administrator").

---

### 5a: Global instruction files — CLAUDE.md and AGENTS.md

**What they are:** Personal standing instructions to each agent — your role, communication preferences, tools you use, standing rules. Both agents read these at the start of every conversation, for every project.

Edit `[repo]/globals/CLAUDE_global.md` and `[repo]/globals/AGENTS_global.md` to reflect your own preferences, then create shortcuts:

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

### 5b: Claude skills — reusable workflows

**What they are:** Skills are reusable multi-step workflows you invoke with a `/command`. Key ones: `/resume_session` (briefing at session start) and `/progress_log` (session summary at end). Skills live in `[repo]/skills/` and need a shortcut so Claude can find them from any project.

**Windows:**
```
mklink /J "C:\Users\[you]\.claude\skills" "[repo]\skills"
```
**Mac:**
```
ln -s "[repo]/skills" "$HOME/.claude/skills"
```

---

### 5c: Claude memory — persistent context across machines

**What it is:** Claude stores facts about you and the project in a memory folder. Without a shortcut, this folder lives outside Dropbox and doesn't sync — e.g., Claude on your work desktop would have no memory of sessions on your laptop. Codex has no equivalent memory system.

**Windows:**
```
mklink /J "C:\Users\[you]\.claude\projects\[hashed-path]\memory" "[repo]\.claude\memory"
```
**Mac:**
```
ln -s "[repo]/.claude/memory" "$HOME/.claude/projects/[hashed-path]/memory"
```

(The hashed path depends on where you cloned the repo, so it's different for everyone. Ask Claude for the exact path: "where is my memory folder for this project?" — then substitute it for `[hashed-path]` above.)

---

### 5d: Claude Code settings — status line and preferences

> **Claude Code only.** Codex has no equivalent status line or settings file.

**`settings.json`** — create a shortcut so preferences sync automatically across your machines:

**Windows:**
```
mklink "C:\Users\[you]\.claude\settings.json" "[repo]\globals\claude_settings.json"
```
**Mac:**
```
ln -s "[repo]/globals/claude_settings.json" "$HOME/.claude/settings.json"
```

**`statusline.sh`** — the status line script is managed by the Claude Statusline VS Code extension, which installs and updates it automatically in `~/.claude/statusline.sh`. You do not need to create a shortcut for it. A reference copy is kept in `[repo]/globals/statusline.sh` for backup.

Once set up, every Claude Code session will show a status bar with model name, context usage, git branch, session and weekly rate limits, session duration, and current folder:
```
claude-sonnet-4-6 │ ████░░░░░░ 42% │  main │ Session:12% │ Weekly:3% │ 47m │ ProjectX
```

> **Want per-machine customization?** Delete a shortcut and replace it with a plain copy (`cp` on Mac, copy-paste on Windows). Changes to that copy won't sync to other machines — useful if you want different voice or theme settings per machine.

---

### 5e: Overleaf setup — per project, once per machine

**Figures and tables — no junction needed.** Stata, R, and Python write output directly to `$OverleafRoot/output/figures/` and `$OverleafRoot/output/tables/` (globals set in `00_setup.do`). Dropbox syncs that real folder to Overleaf cloud. The folders are created automatically on the first run of `master.do`.

> Dropbox does not follow junctions or symlinks that point to other Dropbox folders — it would double-sync. Writing directly to `$OverleafRoot/output/` is the correct approach.

**Reading `.tex` files — one junction IS needed.** AI agents only read files inside the project's working directory (the project's main folder on your machine). `$OverleafRoot` lives outside the project root, so the AI cannot see `.tex` files without help. A junction makes the Overleaf folder appear as a child of the project.

Create it once per machine, per project (no admin needed):

**Windows** (run Command Prompt — no admin required):
```
mklink /J "[path to ProjectX]\tex" "[path to ProjectX_Overleaf]"
```
**Mac** (run in Terminal):
```
ln -s "[path to ProjectX_Overleaf]" "[path to ProjectX]/tex"
```

The `tex/` entry in `.dropboxignore` prevents Dropbox from syncing this per-machine junction to co-authors. See `SETUP.md` in the project root for full details.

---

### 5f: user_profile.md — facts about you

Stores background facts that help Claude calibrate how it explains things (your role, skill level, tools you use). Claude uses this automatically.

The file lives at `[repo]/.claude/memory/user_profile.md` and is already in place after the memory shortcut in Step 5c. Open it and edit it to reflect your own background.

---

## Step 6: Daily Workflow

### When to use Claude Code vs. Codex

Both agents use the same project files (`CLAUDE.md`/`AGENTS.md`, `MEMORY.md`, `progress_logs/`). The difference is in how you work:

| Task | Use |
|------|-----|
| Understanding a project, planning, discussing tradeoffs | **Claude Code** |
| Debugging code interactively, explaining code in plain English | **Claude Code** |
| Writing a single (code-heavy) file or verifying logic interactively | **Claude Code** |
| Translating code across languages (e.g. Stata → R → Python) | **Claude Code** |
| Writing or editing many files in one go | **Codex** |
| Long tasks where the agent works independently for many steps | **Codex** |
| Repeatedly running code, fixing errors, and re-running | **Codex** |

A common pattern: use Claude to plan and define the task, then hand off to Codex to execute.

---

### Starting a session

**Option A — VS Code**

Open the project folder in VS Code, then:
- **Claude Code:** click the asterisk (✳) icon in the top-right toolbar → the chat panel opens.
- **Codex:** click the OpenAI swirl icon in the top-right toolbar → the chat panel opens.

**Option B — Terminal (PowerShell 7 on Windows, Terminal on Mac)**

Navigate to the project folder and start your agent (replace `ProjectX` with your actual project folder name):

Windows:
```
cd "C:\Users\[you]\Dropbox\Research\ProjectX"
claude
```
Mac:
```
cd "$HOME/Dropbox/Research/ProjectX"
claude
```
Replace `claude` with `codex` to start Codex instead.

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
- If Claude starts giving confused or repetitive answers, type `/compact` — this compresses the conversation history so Claude can focus again. (No Codex equivalent; just start a new session.)

---

### Running Stata

With the **Stata Workbench** VS Code extension (installed in Step 1), AI agents can run do-files directly and see output, errors, and graphs without leaving VS Code. This is the recommended workflow — the agent writes code, runs it, reads the results, and iterates automatically.

If you are working without Stata Workbench, the manual fallback is:
1. The agent writes the do-file
2. You run it in Stata
3. Paste any errors back into the chat

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
Claude writes a dated progress log to `progress_logs/`, updates `MEMORY.md`, commits, and pushes — all in one step. If you downloaded new data or wrote new code that reads files or calls external sources, also run `/security-review` before ending the session — it checks for common issues like passwords or API keys accidentally left in the code, or data being saved to a location that shouldn't be public.

**Codex:** Ask manually:
> "Write a progress log for today's session to `progress_logs/YYYY-MM-DD_description.md` and update `MEMORY.md`."

The log captures what was done, decisions made, and what's next. It feeds into `MEMORY.md` so future sessions and co-authors can pick up where you left off.

---

## Step 7: Git — Saving Your Work

Git tracks changes to code files. Use this for mid-session milestones (e.g. after finishing a data cleaning step) — end-of-session commits are handled automatically by `/progress_log` in Step 6. Run in PowerShell 7 (Windows) or Terminal (Mac):

```
git add .
git commit -m "short description of what you did"
git push
```

Either agent can run all of these for you — just ask: *"Commit my changes with the message 'finished income deflation'"*.

**What Git does and doesn't track:**
- Tracks: all code files (`.do`, `.R`, `.py`, `.md`)
- Does not track: data files (`.dta`, `.csv`, `.xlsx`) — those sync via Dropbox
- Does not track: output files (figures, tables) — those are reproduced from code and sync via Dropbox/Overleaf

---

## Quick Reference

| Task | How |
|------|-----|
| Start Claude session (VS Code) | Open project folder in VS Code → click ✳ icon → type `/resume_session` |
| Start Claude session (Terminal) | `cd [project folder]` → `claude` → `/resume_session` |
| Start Codex session (VS Code) | Open project folder in VS Code → click OpenAI swirl icon → ask "Read AGENTS.md and MEMORY.md and tell me where we left off" |
| Start Codex session (Terminal) | `cd [project folder]` → `codex` → "Read AGENTS.md and MEMORY.md and tell me where we left off" |
| Plan before acting | Ask: "Tell me your plan first" |
| End Claude session | `/progress_log` — writes log, updates MEMORY.md, commits and pushes automatically. If you downloaded new data or wrote new code, also run `/security-review` first |
| End Codex session | "Write a progress log to progress_logs/YYYY-MM-DD_description.md and update MEMORY.md" |
| Mid-session Git save | `git add .` → `git commit -m "description"` → `git push` |
| Session getting confused | Type `/compact` in Claude to compress conversation history |
| When to use Claude | Planning, debugging, explaining code, translating code across languages, single-file writing |
| When to use Codex | Many file edits, long autonomous runs, execution-heavy tasks |
