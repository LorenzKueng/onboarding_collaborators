# OpenAI Codex CLI — What It Is and How It Fits Your Workflow

## What Is Codex CLI?

Codex CLI is OpenAI's local coding agent for the terminal. It can read files, edit code, run commands, and work inside the current project directory. 

First, install Node.js:
```bash
winget install OpenJS.NodeJS.LTS
```

Then install Codex CLI it the same way as Claude Code:
```bash
npm install -g @openai/codex
```

Start it with:
```bash
codex
```

You can sign in with your ChatGPT account or use an OpenAI API key.

For your workflow, the important point is this: **Codex is not a replacement for your project structure.** It is another agent that can use the same folders, the same `MEMORY.md`, the same `00_setup.do`, and the same research workflow you already want for Claude.

---

## How Claude Code and Codex CLI Differ

The practical difference is less about "which one is smarter?" and more about **how you want to work**.

| | Claude Code | Codex CLI |
|--|------------|-----------|
| **Interaction style** | More conversational and iterative | Better when you give one clear task and let it run |
| **Instruction file** | `CLAUDE.md` | `AGENTS.md` |
| **Best use** | Interactive research work, debugging, explaining code, planning | Longer coding runs, autonomous edits, terminal-heavy tasks |
| **Approval modes** | Anthropic-style permissions/settings | Built-in `Suggest`, `Auto Edit`, `Full Auto` modes |
| **IDE support** | Claude Code extension / terminal workflows | CLI plus IDE support in VS Code, Cursor, and Windsurf |

In your case, the clean split is:

- **Claude Code** for interactive work: understanding a project, debugging Stata logic, planning a reorganization, discussing tradeoffs.
- **Codex** for execution-heavy work: making many edits, running tests, carrying out well-specified refactors, or doing longer unattended coding tasks.

---

## Are They Using Similar `.md` Files?

Yes. The correspondence is close:

| Claude Code | Codex CLI | Purpose |
|------------|-----------|---------|
| `~/.claude/CLAUDE.md` | `~/.codex/AGENTS.md` | Global personal instructions |
| `ProjectX/CLAUDE.md` | `ProjectX/AGENTS.md` | Local (project-level) instructions |
| `MEMORY.md` | `MEMORY.md` | Current project status snapshot |
| `progress_logs/` | `progress_logs/` | Session history |

So if a project already works well with `CLAUDE.md`, you do **not** need a new project structure for Codex. You mainly need:

1. A global `AGENTS.md` for your personal standing instructions.
2. A local, project-level `AGENTS.md` in each repo where you want Codex to inherit local rules.

The easiest approach is to start by copying the corresponding Claude files and then trim them if needed.

---

## What You Would Need to Change to Move from Claude Code to Codex

You do **not** need to redesign your folders. The migration is mostly about instruction files and workflow.

### 1. Add Codex instruction files

- Create `C:\Users\[you]\.codex\AGENTS.md`
- For each project, create `ProjectX\AGENTS.md`

Those can initially be copied from your existing Claude files:

- `CLAUDE_global.md` -> `AGENTS_global.md`
- `ProjectX\CLAUDE.md` -> `ProjectX\AGENTS.md`

### 2. Keep the same project memory workflow

Your current system already makes sense for Codex:

- `MEMORY.md` stays the current-status file
- `progress_logs/` stays the running history
- `00_setup.do` still defines paths and globals

Codex does not require you to replace any of that.

### 3. Set Codex technical preferences in `config.toml`

Codex uses `C:\Users\[you]\.codex\config.toml` for technical settings such as model choice, approvals, and MCP/tool configuration. This is the rough equivalent of Claude's settings files.

### 4. Adjust how you prompt

This is the main behavioral change.

With Claude, your natural style is:
- discuss
- refine
- ask for a plan
- execute in smaller steps

With Codex, the better pattern is:
- give the full task up front
- specify the files and constraints
- let it work
- review the diff and results afterward

So the migration is mostly a **workflow shift**, not a file-structure shift.

---

## Best Way to Use Both Claude Code and Codex

For you, the best arrangement is:

- Use **Claude Code** as the research RA.
- Use **Codex** as the implementation worker.

Concretely:

| Task | Best tool |
|------|-----------|
| Understanding a project, planning a reorganization | Claude Code |
| Explaining code in plain English | Claude Code |
| Debugging interactively, especially when you want discussion | Claude Code |
| Large batches of edits across many files | Codex |
| Longer autonomous coding tasks | Codex |
| Terminal-heavy work and repeated edit/run/fix loops | Codex |

That means you do **not** need to choose one tool exclusively. The workflow can be:

1. Use Claude to think through the task and define the rules.
2. Use Codex to execute the concrete implementation.
3. Use Claude again to review, explain, or refine the result.

---

## Should You Use Cursor Too?

Probably only if you find the editor itself valuable.

Cursor is mainly an IDE. It is useful if you want an editor-centered workflow with inline AI help while typing. But it is not necessary for the Claude + Codex combination.

For your setup, the clean recommendation is:

- If you like working in **VS Code + terminal**, then Claude Code + Codex are probably enough.
- Keep **Cursor** only if you genuinely use its editor features a lot.
- If most of your work happens through terminal agents and Overleaf/Stata, Cursor may be redundant.

So the default answer is: **use Claude Code and Codex first; treat Cursor as optional.**

---

## Practical Recommendation for You

For your economics workflow:

1. Keep using Claude Code as the main interactive assistant.
2. Add Codex for autonomous coding runs and heavier implementation tasks.
3. Reuse the same project structure, `MEMORY.md`, and progress-log workflow.
4. Create `AGENTS_global.md` now and symlink it to `C:\Users\[you]\.codex\AGENTS.md`.
5. When you start using Codex on a project, copy that project's `CLAUDE.md` to `AGENTS.md`.

That gives you the benefits of Codex without forcing a full switch away from Claude.

---

## Handling Daily / Weekly Limits (Overage via API Key)

If you sign in with your ChatGPT account, Codex uses your ChatGPT-plan quota. When that quota is used up for the day or week, Codex stops — unless you also have an **OpenAI API key** set. If both are configured, Codex uses your ChatGPT quota first and then transparently falls back to metered API usage (you pay per-token). This is what "overage" means here.

**Do you need an API key?** Only if you want to keep working after hitting the ChatGPT limit. If you're fine waiting until the quota resets, you don't need one.

### 1. Create the key
1. Go to <https://platform.openai.com/api-keys>.
2. Click **Create new secret key**, give it a name like `codex-cli`.
3. Copy the key (starts with `sk-...`) — you won't be able to see it again.

### 2. Make sure your account has credit
At <https://platform.openai.com/settings/organization/billing>, check that you have a payment method and credit balance. Without credit the API call will fail even with a valid key.

### 3. Set the key on Windows
In PowerShell, **one time** (persists across reboots):
```powershell
setx OPENAI_API_KEY "sk-..."
```
Close and reopen PowerShell for the variable to take effect. Verify with:
```powershell
echo $env:OPENAI_API_KEY
```

(You can also paste the key into `C:\Users\[you]\.codex\auth.json`, but the env-var route is simpler and doesn't require editing that file by hand.)

### 4. How Codex chooses which credential to use
- If you're signed in with ChatGPT (via `codex login`), that's used first.
- If the ChatGPT quota is exhausted, Codex falls back to `OPENAI_API_KEY`.
- If you only have `OPENAI_API_KEY` and no ChatGPT login, Codex uses the API from the start (fully metered).

### 5. Cost control
API usage is billed per token. To avoid surprises:
- Set a **monthly budget cap** at <https://platform.openai.com/settings/organization/limits>.
- Start with a small cap ($10–20) to see your actual usage before raising it.

---

## Quick Setup Checklist

- [ ] Install Codex: `npm install -g @openai/codex`
- [ ] Start it once: `codex`
- [ ] Create or symlink `C:\Users\[you]\.codex\AGENTS.md`
- [ ] Create `AGENTS.md` inside any project where you want local Codex instructions
- [ ] Keep using `MEMORY.md` and `progress_logs/`
- [ ] (Optional) Set `OPENAI_API_KEY` for overage past the ChatGPT quota
- [ ] Use Claude for planning and explanation; use Codex for execution-heavy work
