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

## Mirror
Canonical copy: `AI_tools/documents/AI_browser_extensions.md` — keep both in sync.
