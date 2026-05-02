# Source provenance

**Skill:** `prompt`
**Imported from:** https://github.com/chrisblattman/claudeblattman/blob/main/skills/prompt.md
**Companion files:** `skills/prompt-references/formatting-core.md` (bundled here as `formatting-core.md`)
**Author:** Chris Blattman
**License:** see https://github.com/chrisblattman/claudeblattman/blob/main/LICENSE
**Upstream commit at import:** `93fc6a6` (main, fetched 2026-04-30)
**Imported by:** Lorenz Kueng (Claude Code session, 2026-04-30)

## Adaptation notes

- Added YAML frontmatter (`name`, `description`) to fit the SKILL.md format Lorenz uses (Blattman's originals are slash-command files, not skills).
- Changed `@~/.claude/commands/prompt-references/formatting-core.md` reference to `@formatting-core.md` (bundled inside this skill dir).
- No semantic changes to the prompt logic.

## Updating

To pull the latest upstream version:

```bash
gh api repos/chrisblattman/claudeblattman/contents/skills/prompt.md --jq '.content' | base64 -d
gh api repos/chrisblattman/claudeblattman/contents/skills/prompt-references/formatting-core.md --jq '.content' | base64 -d
```

Re-apply the two adaptations above (frontmatter + reference path).

## Why this file is a sidecar

Claude only reads `SKILL.md` (and any `@`-referenced files) when this skill is invoked. Sibling files like this one are not auto-loaded, so source/version metadata stays out of the prompt context.
