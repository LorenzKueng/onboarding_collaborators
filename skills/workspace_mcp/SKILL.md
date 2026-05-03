---
name: workspace_mcp
description: Start the Google Workspace MCP server so Claude Code can access Gmail, Google Drive, Docs, and Sheets. Invoke when the user wants to read emails or Drive files, or when workspace tools are unavailable.
---

# Skill: workspace_mcp

## What this skill does
Starts the `workspace-mcp` server (if not already running) so that Gmail, Drive, Docs, and Sheets tools become available in this Claude Code session.

## Prerequisites
- `uv` installed (`uv --version` should work in PowerShell).
- Google OAuth credentials saved as Windows environment variables (`GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET`). Save permanently with `setx` (one-time per machine; see your project's Gmail/Drive integration guide).
- `workspace-mcp` registered in Claude Code at **user scope** (one-time per machine):
  ```powershell
  claude mcp add --transport http --scope user workspace-mcp http://localhost:8000/mcp
  ```
  Note: `--scope user` makes it available in all projects. Valid scopes: `user`, `project`, `local` — **not** `global`.

## Steps Claude should follow

### Step 1 — Check if the server is already running
Run this via the **Bash** tool (not PowerShell — see note):
```bash
netstat -ano | grep -E ":8000[[:space:]]+\S+[[:space:]]+LISTENING" && echo "STATUS: RUNNING" || echo "STATUS: NOT_RUNNING"
```
- `STATUS: RUNNING` (and a `TCP ... :8000 ... LISTENING` line) → server is up. Skip to Step 3.
- `STATUS: NOT_RUNNING` → proceed to Step 2.

Note: do **not** use `Test-NetConnection` from the PowerShell tool for this check. In some Claude Code sessions on Windows the PowerShell tool returns exit code 1 with empty output for *every* command (including `"hello world"`), making a "False" result indistinguishable from a broken tool — and Claude will then falsely tell the user to start an already-running server. `netstat` via Bash reads the kernel's TCP listener table directly and is reliable.

### Step 2 — Ask the user to start the server
**Do not try `Start-Process` from this harness.** The new PowerShell window does not become visible to the user, so the server never actually starts. Instead, instruct the user to open a fresh PowerShell window themselves and paste this one line:

```powershell
uvx workspace-mcp --tool-tier core --transport streamable-http
```

How to open PowerShell on Windows 11: press `Win + X` → click **Terminal** (or **Windows PowerShell**), or press `Win` and type "powershell".

Tell the user the window must stay open for the rest of the Claude session — closing it kills the server.

Wait for the user to confirm the server is running ("running", "started", "done", etc.) before moving on. Do not poll.

### Step 3 — Verify and confirm
After the user confirms, re-run the Step 1 check.
- If the port is now open: tell the user Gmail/Drive/Docs/Sheets tools are available in this session, and remind them to keep the server window open.
- If the port is still closed: surface the troubleshooting section below.

## Daily use reminder
The server must be started once per Windows session (it does not auto-start). The MCP registration is permanent and does not need to be repeated.

## Troubleshooting
- **`uvx` not found**: reinstall `uv` with `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"` then restart PowerShell.
- **OAuth error on first run**: a browser window should open — click Allow.
- **Port 8000 in use**: `Get-Process -Id (Get-NetTCPConnection -LocalPort 8000).OwningProcess | Stop-Process`, then retry Step 2.

## When the server is running — Workspace context to load

Before creating, modifying, or searching content in the user's Google Workspace, check the auto-memory at `~/.claude/projects/<project-hash>/memory/` for relevant reference files. Currently:

- **`reference_google_calendars.md`** — list of all 22 calendar IDs and the rule "default work / nudge / procurement events to TEACHING/SERVICE, not primary." Read this before any `manage_event` create / update.

If the user asks about a calendar, label, folder, or contact you don't have an ID for, run the matching `list_*` tool and offer to update the reference file.
