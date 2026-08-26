---
name: workspace_mcp
description: Start the Google Workspace MCP server so Claude Code can access Gmail, Google Drive, Docs, Sheets, and Calendar tools when your workflow uses them.
---

# Skill: workspace_mcp

## What this skill does
Starts the `workspace-mcp` server if it is not already running, then verifies that Claude Code can reach it.

## Prerequisites
- `uv` installed (`uv --version` should work in PowerShell).
- Google OAuth credentials saved as Windows environment variables (`GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET`) or configured by your chosen MCP setup guide.
- `WORKSPACE_MCP_HOST=127.0.0.1` and `WORKSPACE_MCP_PORT=8000` persisted via environment variables. This keeps the server bound to localhost instead of all network interfaces.
- `workspace-mcp` registered in Claude Code at user scope:
  ```powershell
  claude mcp add --transport http --scope user workspace-mcp http://localhost:8000/mcp
  ```
  Valid scopes are `user`, `project`, and `local`; not `global`.
- Optional but recommended on Windows: create a Scheduled Task that starts the server at login with a short delay. This is more reliable than a Startup-folder shortcut and gives you an event log when it runs.

## Steps Claude should follow

### Step 1 - Check whether the server is already running
Use a TCP listener check. On Windows, prefer `netstat` rather than `Test-NetConnection` inside an AI harness, because some sessions report false negatives from PowerShell state checks.

```bash
netstat -ano | grep -E ":8000[[:space:]]+\S+[[:space:]]+LISTENING" && echo "STATUS: RUNNING" || echo "STATUS: NOT RUNNING"
```

If the server is running, continue to Step 3.

### Step 2 - Ask the user to start the server
Do not silently launch a hidden PowerShell window from the AI harness. Ask the user to start the server in a visible terminal or trigger their scheduled task.

Preferred manual command:

```powershell
uvx workspace-mcp --tool-tier extended --transport streamable-http
```

Use the `extended` tier when the workflow needs Gmail drafts, labels, or thread tools. A `core` tier can be enough for simpler Drive/Docs/Sheets use.

If a Scheduled Task is configured, the user can start it manually:

```powershell
Start-ScheduledTask -TaskName "Workspace MCP Server"
```

After the user confirms, rerun the Step 1 listener check.

### Step 3 - Verify MCP connection
In Claude Code, run `/mcp` and verify that `workspace-mcp` is connected. If the server's tool tier changed while Claude Code was already open, reconnect via `/mcp` or restart Claude Code so the new tools register.

### Step 4 - Load workspace context before acting
Before creating, modifying, or searching Google Workspace content, read the relevant project instructions and memory files. If the project records calendar IDs, Gmail labels, Drive folder IDs, or sender rules, use those instead of guessing.

If the user asks about a calendar, label, folder, or contact and no ID is recorded, use the matching list/search tool and offer to record the result in project memory for next time.

## Troubleshooting
- **`uvx` not found:** install or reinstall `uv`, then restart PowerShell.
- **OAuth error on first run:** a browser window should open; click Allow. If it does not open, copy the printed URL into the browser profile you intend to use for this account.
- **Port 8000 already in use:** identify the process with `Get-NetTCPConnection -LocalPort 8000`, stop it if appropriate, then retry Step 2.
- **Tools missing after startup:** reconnect the MCP server or restart Claude Code, especially after changing the tool tier.

## Safety notes
- Keep OAuth credentials out of git.
- Bind to `127.0.0.1` unless you have a deliberate reason to expose the server on your network.
- Draft emails, calendar updates, and file modifications should be reviewed before sending or applying when they affect other people.