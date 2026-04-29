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
```powershell
Test-NetConnection -ComputerName localhost -Port 8000 -InformationLevel Quiet
```
- `True` → server is up. Skip to Step 3.
- `False` / error → proceed to Step 2.

### Step 2 — Start the server in a new PowerShell window
```powershell
Start-Process powershell -ArgumentList '-NoExit -Command "uvx workspace-mcp --tool-tier core --transport streamable-http"'
```
Wait 5 seconds, then re-run the Step 1 check to confirm the server came up.

### Step 3 — Confirm to the user
Tell the user:
- Whether the server was already running or was just started.
- That Gmail/Drive/Docs/Sheets tools are now available in this session.
- The server window must stay open; closing it will disconnect the tools.

## Daily use reminder
The server must be started once per Windows session (it does not auto-start). The MCP registration is permanent and does not need to be repeated.

## Troubleshooting
- **`uvx` not found**: reinstall `uv` with `powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"` then restart PowerShell.
- **OAuth error on first run**: a browser window should open — click Allow.
- **Port 8000 in use**: `Get-Process -Id (Get-NetTCPConnection -LocalPort 8000).OwningProcess | Stop-Process`, then retry Step 2.
