# Giving AI control of Google Chrome (Claude for Chrome + Codex for Chrome)

Browser-control agents can read and act on pages **using your signed-in browser state**. This guide is the install, safety, and per-machine rollout reference for collaborators.

> Claude Code / Codex cannot install these for you. Installation is a manual Chrome Web Store + sign-in flow done by the user in Chrome.

## The two tools

| | Claude for Chrome | Codex for Chrome |
|---|---|---|
| Vendor | Anthropic | OpenAI |
| What | Sidebar agent that acts on web pages; can record/replay workflows | Lets Codex use your signed-in Chrome to read/act on sites, test web apps, and inspect DevTools |
| Requires | A paid Claude plan | A ChatGPT/OpenAI plan + the Codex app/CLI |
| Install via | Chrome Web Store (Anthropic publisher) | Codex app -> Plugins -> add Chrome plugin |
| Browser | Chrome | Chrome only |

## Current safe-profile setup

- Use a dedicated Chrome profile named **AI** (or a name starting with `AI`, such as `AI Research`) for AI-controlled browsing.
- Sign the AI profile into only the accounts you are comfortable letting an AI-assisted browser use. Do not store account emails, phone numbers, passwords, recovery details, backup codes, or password-manager exports in this repo.
- Keep your main/personal Chrome profile out of AI browser-control workflows.
- Install browser-control extensions in the AI profile only.
- Codex Chrome may be enabled in the dedicated AI profile. Keep the extension out of personal profiles, pin Codex's selector to the AI profile, and visibly confirm the controlled window before acting. Chrome's `"started debugging this browser"` information bar can appear globally in windows belonging to other profiles; the banner alone is not evidence that those profiles are accessible.

## Profile directory names

Chrome's `--profile-directory` flag needs the profile's directory name (`Profile 3`, `Profile 7`, etc.), not the display name shown in Chrome's profile picker. Directory names differ across machines, so never hard-code another person's value.

To print the mapping on Windows, run this one-liner:

```powershell
python -c "import json,os; p=os.path.expandvars(r'%LOCALAPPDATA%\Google\Chrome\User Data\Local State'); d=json.load(open(p,encoding='utf-8')); [print(k,'=',v.get('name')) for k,v in d['profile']['info_cache'].items()]"
```

Use the directory whose displayed name is your dedicated AI profile.

## Opening a URL from the CLI without leaking into the personal profile

Chrome sends a URL to its **last-used profile** whenever the URL arrives through the operating system's default-browser handler. These routes are unsafe for AI-driven browsing because they may open your personal profile: PowerShell `Start-Process` with a bare URL, `start`, `explorer.exe`, `cmd /c start`, `gh browse`, and `gh ... --web`.

Pin the AI profile explicitly and force a separate window instead:

```powershell
Start-Process "chrome.exe" -ArgumentList '--profile-directory="<AI profile dir>"','--new-window','<url>'
```

Keep the inner quotes around the profile directory. Without them, a directory such as `Profile 12` can split and Chrome may interpret `12` as a URL.

## Codex Chrome caution

The Codex Chrome plugin has an extra moving part: it may run through a helper process that chooses a Chrome profile separately from the shell command that launched Chrome. Pin that selector to the dedicated AI profile and confirm that its diagnostic reports the AI profile with the plugin enabled. Before using any Codex Chrome browser-control path:

1. Confirm the visible Chrome UI is the dedicated AI profile.
2. Stop if the controlled page, profile badge, account, bookmarks, or page context suggest a personal profile. Do not treat the global debugger banner by itself as evidence of access.
3. Prefer purpose-built connectors, the Codex in-app browser, or a manual AI-profile step when profile verification is ambiguous.
4. Keep the extension installed and enabled only in the dedicated AI profile.

If you maintain a shared Codex config, record the per-machine AI-profile selector and verify it after setup changes.

## Optional enforcement for Claude Code

A guard script such as `scripts/chrome_profile_guard.py` can be wired as a Claude Code `PreToolUse` hook to deny shell commands that open a browser without a quoted AI profile flag and `--new-window`. The recommended behavior is fail-closed: if no AI profile can be identified, block browser launches rather than guessing a directory name.

After setup, test the hook with a harmless intentionally unsafe command and confirm the hook blocks it before relying on it.

## Install steps

**Claude for Chrome**
1. Open Chrome in the dedicated AI profile.
2. Sign in with an active Claude account.
3. Install Claude for Chrome from the Chrome Web Store under the Anthropic publisher.
4. Pin the extension, sign in, enable it per conversation, and grant per-site permissions only as needed.

**Codex for Chrome**
1. Open the Codex app/CLI and sign in with the relevant ChatGPT/OpenAI account.
2. In Codex, open Plugins and add the Chrome plugin.
3. Follow the install and permission prompts in Chrome.
4. Use per-site approvals and allowlist/blocklist settings.
5. Keep the plugin enabled only in the dedicated AI profile and visibly confirm that profile before each controlled task.

## Safety posture

Browser agents are exposed to prompt injection: hidden or visible page text that tries to steer the agent away from your instructions. Treat web pages as untrusted inputs.

1. Use a dedicated Chrome profile that is not logged into online banking, payment systems, or your primary personal email.
2. Keep bookings, purchases, payments, and irreversible submissions human-approved.
3. Start with trusted sites, grant permissions per site, and review any action touching money, personal data, or work-critical data.
4. Prefer browser agents for read, gather, compare, and draft tasks; treat write/spend/submit actions as stop-and-confirm.
5. Do not store recovery data, backup codes, password exports, or private account identifiers in this repo.

## Per-machine rollout

On each machine:

1. Create or identify the dedicated AI Chrome profile.
2. Install only the browser extensions you need in that profile.
3. Resolve the local profile directory name.
4. Configure any hooks or Codex settings to use the local AI profile.
5. Verify the visible browser UI before the first controlled browsing task.

## Mirror

Private workflow repos may keep a more specific copy with local paths and machine status. This public copy should stay generic and safe for collaborators.
