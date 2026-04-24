# Software Guide: What to Install and Use

---

## Terminal Apps: Which One to Use

When working with Claude Code from the command line, you encounter several apps that look similar but play different roles.

**The shells — these do the actual work:**

| App | What it is | Recommendation |
|-----|-----------|----------------|
| Command Prompt | The classic Windows shell. Basic, no colors. | Skip — outdated |
| Windows PowerShell | Comes with Windows. Adequate but aging. | Fine, but not ideal |
| PowerShell 7 | The modern version. Must be installed separately. Faster and more capable. | **Use this** |

**Windows Terminal — optional but recommended to run PowerShell 7:**

Windows Terminal is just a nicer-looking window for running any of the shells above. Think of it like a TV screen: PowerShell 7 does the actual work (like a cable provider sending the signal), Windows Terminal just makes it look better — tabs, colors, nicer fonts. You can skip it and open PowerShell 7 directly from the Start menu and everything works identically.

To make Windows Terminal open PowerShell 7 by default: open Windows Terminal → click the dropdown arrow next to the `+` tab → Settings → "Default profile" → select "PowerShell" (the PowerShell 7 one, not "Windows PowerShell") → Save.

**VS Code — for code editing:**

VS Code is a text editor for code — like Word, but designed for writing do-files, R scripts, and Python scripts. It has a Claude Code extension that integrates directly into the sidebar (View > Extension Panel > search "Claude Code"). OpenAI also has a VS Code extension for Codex (search "Codex" in the Extension Panel). VS Code also has a terminal panel built into the bottom of the window (View \> Terminal), so you can edit your do-file at the top and run Claude Code at the bottom without switching windows.

The terminal inside VS Code runs PowerShell 7 and can do everything Windows Terminal can — same commands, same capabilities. **The one exception: if you're running a long overnight job, use Windows Terminal** instead, so the job keeps running even if you close VS Code.

**VS Code Extensions to install** (Ctrl+Shift+X → search name → Install):

| Extension | Search term | What it does |
|-----------|-------------|--------------|
| Claude Code | "Claude Code" | Integrates Claude Code into the sidebar |
| Claude Statusline | "Claude Statusline" | Shows model, context window usage, and session usage in the VS Code status bar |
| Codex | "Codex" | OpenAI's Codex assistant in the sidebar |
| Stata Workbench | "Stata Workbench" | Run Stata do-files from VS Code; also enables Claude Code to interact with Stata directly via MCP (see MCP setup below) |

**What to install and use:**
1. Install PowerShell 7 (one-time setup)
2. Install Windows Terminal — set PowerShell 7 as the default profile
3. Install VS Code and the extensions above. Use it day-to-day for writing and running code; open Windows Terminal only for long overnight jobs

---

## The Different Claude Products

There are three main ways to access Claude:

**1. claude.ai (website, in your browser)**
Chat only. Good for writing, brainstorming, quick questions. Cannot access your local files.

**2. Claude Desktop App** (downloadable — different from the website)
One app with three modes:

| Mode | What it does |
|------|-------------|
| **Chat** | Same as the website, but as a desktop app |
| **Cowork** | Autonomous agent (released publicly April 2026) — completes multi-step tasks on your computer, works with local files, without you prompting each step |
| **Code** | Claude Code integrated into the desktop app |

Works with local files and MCP servers. Good for quick local tasks.

**3. Claude Code CLI — your primary tool**
Runs in the terminal. For your workflow, this is the right choice for three reasons:

- **Overnight jobs** — a job running in Windows Terminal keeps going unattended. The Desktop App may pause.
- **Scheduled automation** — Windows Task Scheduler can trigger CLI commands automatically (e.g., every Monday at 8am). Not possible with the Desktop App.
- **Remote servers and HPC** — the CLI runs over SSH on Linux servers, including your university server and eventually the ETH Lugano supercomputer. The Desktop App only runs on your local machine.

One important note on HPC: supercomputers use a job queue system — you submit a script and it runs when resources are available. Claude Code CLI won't run interactively on the HPC itself. The workflow will be: use Claude locally to write and test your scripts, then submit them to the HPC queue yourself. Claude Code CLI will work on your university server for interactive tasks.

---

## OpenAI Equivalents: Codex/GPT

| Claude product | OpenAI equivalent | Notes |
|---------------|------------------|-------|
| claude.ai (website) | ChatGPT (chatgpt.com) | Direct equivalent |
| Claude Desktop App | ChatGPT Desktop App | Available for Windows and Mac |
| Claude Cowork | OpenAI Agents SDK | OpenAI's version requires more developer setup |
| Claude Code CLI | OpenAI Codex CLI | Direct competitor — launched April 2025, actively developed |

**Claude Code vs. Codex CLI — the key differences:**

| | Claude Code | Codex CLI |
|--|------------|-----------|
| Cost | Token-based (adds up for heavy use) | $20/month flat (included with ChatGPT Plus) |
| Workflow | Collaborative — works through tasks with you, step by step | Autonomous — you submit a task, review results later |
| Code quality | More careful and thorough | Faster but may need more oversight |
| Token efficiency | Higher consumption | ~4x more efficient |
| Open source | No | Yes |

For your workflow: the flat $20/month pricing of Codex could be cheaper if you run heavy overnight jobs — token costs with Claude Code add up fast for long sessions. On the other hand, Claude Code's collaborative, step-by-step approach may catch more errors in research code where accuracy matters. Worth knowing about as an alternative, especially as your automation needs grow.

---

## Cursor

A code editor (like Word, but for code) with AI built in. VS Code under the hood, but purpose-built for AI-assisted coding. Your colleagues likely use it because it's the most user-friendly option for interactive code writing.

**How it differs from Claude Code CLI and Codex CLI:**
- **Cursor** = you're in the driver's seat, editing code, and AI assists you as you work — autocomplete, inline suggestions, "change this function to do X"
- **Claude Code / Codex** = you describe a task and step back — the AI drives, reads files, writes code, runs commands autonomously

They're complementary, not competing. Use Cursor for writing and editing scripts; use Claude Code for autonomous overnight jobs and pipelines.

**AI model selection:** Cursor's "Auto" mode automatically routes each query to whichever model it judges best — Claude, GPT, Gemini, or others — based on cost and task complexity. You don't need to pick manually, though you can override it.

**API keys:** Don't add your own Anthropic or OpenAI API keys to start. The $20/month Pro plan already includes model access and API credits. Add your own keys only if you hit usage limits or need a model not in Cursor's lineup. If you do add keys, set spending limits on your Anthropic/OpenAI accounts first — treat API keys like passwords.

**Stata support:** There is a Stata MCP extension for Cursor that lets you run `.do` files directly from the editor. Stata is not Cursor's strongest suit (Python and R get better AI support), but it works.

**Worth paying for?** Yes — your colleagues use it, and as you move toward R and Python as primary execution languages, Cursor's interactive assistance becomes genuinely useful. The $20/month covers interactive editing; Claude Code handles the autonomous overnight work. Different tools, different jobs.

---

## Microsoft Copilot vs. GitHub Copilot

The "Copilot" name is confusing — Microsoft uses it for several unrelated products:

| Product | What it is | Relevant to you? |
|---------|-----------|-----------------|
| **Microsoft Copilot 365** | AI assistant built into Word, Excel, Outlook, PowerPoint | Mildly — useful for email and documents, but you use LaTeX not Word |
| **GitHub Copilot** | AI coding assistant built into VS Code and other editors — autocompletes code as you type | Yes — but Cursor is more powerful and already does this |
| **Bing / Windows Copilot** | AI assistant in Microsoft's search engine and Windows — essentially ChatGPT with Bing search | Not really |

**The key distinction:** Microsoft Copilot 365 is for Office productivity. GitHub Copilot is for writing code. They share a name but have nothing to do with each other.

**GitHub Copilot vs. Cursor:** Both are AI coding assistants that live inside your editor. Cursor is generally more capable, especially for multi-file editing. GitHub Copilot is cheaper (included in some GitHub plans) and more common in corporate settings. For research workflows, Cursor is the better choice.

---

## When to Use Which

- Writing, brainstorming, quick questions → Claude.ai or Desktop App (Chat)
- Autonomous multi-step tasks on local files → Desktop App (Cowork)
- Interactively writing and editing code (do-files, R, Python) → Cursor
- Overnight jobs, scheduled automation, remote servers, HPC → Claude Code CLI
- Cost-sensitive heavy automation (alternative to Claude Code) → Codex CLI
