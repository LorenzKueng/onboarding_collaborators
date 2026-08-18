# Giving AI control of Google Chrome (Claude for Chrome + Codex for Chrome)

Two browser-control agents let an AI read and act on pages **using your signed-in browser state**. This doc is the install + safety reference.

> Claude Code / Codex cannot install these for you — installation is a manual Chrome Web Store + sign-in flow done by the user.

## The two tools

| | Claude for Chrome | Codex for Chrome |
|---|---|---|
| Vendor | Anthropic | OpenAI |
| What | Sidebar agent that acts on web pages; can record/replay workflows | Lets Codex use your signed-in Chrome to read/act on sites, test web apps, read DevTools |
| Requires | A paid Claude plan (Pro/Max/Team/Enterprise) | A ChatGPT/OpenAI plan + the Codex app/CLI |
| Install via | Chrome Web Store (Anthropic publisher) | Codex app → Plugins → add Chrome plugin |
| Region | Broadly available | Blocked in the EU and the UK (launched 8 May 2026). Won't work while physically in the UK. |
| Browser | Chrome | Chrome only |

## Current safe-profile setup
- Use Chrome profile **AI** for AI-controlled browsing.
- The AI profile should be signed into a dedicated AI-workflow Google account. Do not record account emails, phone numbers, passwords, recovery details, or exported password contents in this repo.
- The AI profile may have both **Claude for Chrome** and **Codex for Chrome** installed. Claude for Chrome gives Claude access from the browser sidebar; it does **not** by itself give the Claude Code CLI browser-control tools.
- Keep the main/personal Chrome profile out of AI browser-control workflows.
- **Find your AI profile's directory name.** Chrome's `--profile-directory` flag needs the directory name (`Profile 3`, `Profile 7`, ...), not the display name shown in the profile picker. Run this one-liner and read the mapping:
  `python -c "import json;d=json.load(open(r'%LOCALAPPDATA%\\Google\\Chrome\\User Data\\Local State',encoding='utf-8'));[print(k,'=',v.get('name')) for k,v in d['profile']['info_cache'].items()]"`
- Install the browser extension in the AI profile **only**. That way the `mcp__claude-in-chrome__*` tools cannot reach your personal profile at all.

## Opening a URL from the CLI without leaking into the personal profile
Chrome sends a URL to its **last-used profile** whenever that URL arrives through the OS default-browser handler. If your last-used profile is the personal one, every default-handler route lands there: PowerShell `Start-Process` with a bare URL, `start`, `explorer.exe`, `cmd /c start`, `gh browse`, and `gh ... --web`. The extension and the AI profile are bypassed entirely.

Pin the profile explicitly instead, on one line, substituting your own directory name:

```
Start-Process "chrome.exe" -ArgumentList '--profile-directory=<AI dir>','<url>'
```

**Optional enforcement.** `AI_tools/scripts/chrome_profile_guard.py` can be wired as a Claude Code `PreToolUse` hook (matcher `Bash|PowerShell`) to deny any shell command that opens a browser without the profile flag, returning the correct rewrite in the denial message. No per-machine editing is needed: the script matches any Chrome profile whose display name starts with "AI" as a whole word ("AI", "AI Access", "AI-workflow"), so name your profile accordingly and it resolves on any machine. Run it with `--print-profile-dir` to see what it resolved to. If it finds no such profile it fails closed and blocks all browser launches, rather than guessing a directory name that would make Chrome create a new empty profile.

## Install steps (in Chrome)
**Claude for Chrome:** sign into Chrome with an active paid Claude account → Chrome Web Store → Anthropic publisher → Claude for Chrome → Add to Chrome → sign in → enable per conversation, grant per-site permissions.
- https://support.anthropic.com/en/articles/12012173-getting-started-with-claude-for-chrome

**Codex for Chrome:** install Codex app/CLI + sign into ChatGPT → Codex → Plugins → add the Chrome plugin → follow the setup (installs the extension, approve Chrome prompts) → use per-site approvals + allowlist/blocklist.
- https://developers.openai.com/codex/app/chrome-extension

## Safety posture
Browser agents are exposed to **prompt injection** (hidden page instructions). Therefore:
1. Use a **dedicated Chrome profile** not logged into online banking or primary email.
2. Keep **bookings and payments human-approved** — the agent fills, you click Pay.
3. Start with trusted sites, grant **per-site**, review any money/personal/work-critical action.
4. Use the agent for read/gather/draft; treat write/spend as stop-and-confirm.
5. Do not store personal recovery data here: no account emails, phone numbers, passwords, backup codes, or password-manager exports.

**Per-machine check.** After setting up a new machine (or after Dropbox syncs changes to it), run `python "$HOME/Dropbox/Work/Templates/AI/AI_tools/scripts/check_chrome_profile_setup.py"`. It lists the Chrome profiles, shows which directory the guard resolves as the AI profile, confirms the PreToolUse hook is wired into the active settings.json, and warns if the browser extension is installed in any profile other than AI.

## Mirror
Canonical copy: `AI_tools/documents/AI_browser_extensions.md` — keep both in sync.
