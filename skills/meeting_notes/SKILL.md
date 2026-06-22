---
name: meeting_notes
description: Summarize a meeting transcript (MS Teams, Fireflies, etc.) into a fixed-shape summary — overview, decisions, numbered action items with owners, open questions — then, after showing the extracted items, append the action items to the project's _Tasks_for_the_AI.md and drop a pointer in the current progress log. Use when the user has a meeting recording/transcript to process into next steps.
argument-hint: "[path to transcript file] (optional — otherwise asks)"
---

# Meeting Notes — transcript → summary + next steps

Turn a raw meeting transcript into a durable summary and a vetted to-do list. Transcripts come from MS Teams, Fireflies, Otter, Zoom, or a pasted block of text.

## Where files live

Per the project directory structure (`Project_setup.md`), meeting files live in **`correspondence/meeting_notes/`**, raw and summary side by side, dated:
- `correspondence/meeting_notes/YYYY-MM-DD_<short-topic>_transcript.<ext>` — raw export
- `correspondence/meeting_notes/YYYY-MM-DD_<short-topic>_summary.md` — what this skill writes

Raw transcripts are git-ignored (`correspondence/meeting_notes/*_transcript.*`); the summary is committed. If the project has no `correspondence/meeting_notes/` folder yet, create it.

## Steps

### 1. Locate the transcript
- If the user gave a path or pasted text, use it. Otherwise look in `correspondence/meeting_notes/` for a `*_transcript.*` without a matching `*_summary.md`, and confirm which one to process.
- If the file is somewhere else (Downloads, Teams export), offer to move/copy it into `correspondence/meeting_notes/` with the dated naming convention first.

### 2. Read the full transcript
First check the file format. MS Teams exports transcripts as **`.docx`**, which is zipped XML, not plain text — convert it to text/markdown before reading (e.g. `pandoc "file_transcript.docx" -t markdown -o "file_transcript.md"`, or read the converted text). Fireflies, Otter, and Zoom can export `.md`/`.txt`/`.srt`/`.vtt` directly, which are read as-is. `.srt`/`.vtt` carry timestamps you can strip.

Read the whole thing, not just the first matches — decisions and action items are scattered throughout and often land near the end. For long transcripts, read in chunks so nothing is missed.

### 3. Produce the summary (fixed shape)
Write to `correspondence/meeting_notes/YYYY-MM-DD_<topic>_summary.md`:

```markdown
# Meeting summary — [YYYY-MM-DD] [Topic]

**Participants:** [names, if identifiable from the transcript]
**Source:** [transcript filename]

## Overview
[3-5 sentences: what the meeting was about and where things landed. No throat-clearing.]

## Decisions
- [decision 1]
- [decision 2]

## Action items
1. [OWNER] [the task]
2. [OWNER] [the task]
   - 2a. [sub-item if any]

## Open questions
- [unresolved question 1]
```

Conventions:
- **Tag every action item with an owner** in square brackets — `[LK]`, `[co-author initials]`, or `[unassigned]` if the transcript didn't say. Match the project's existing initials convention.
- Action items are a **numbered list** (sub-items `2a`, `2b`) so they can be discussed by number.
- Internal-notes register — accurate and terse. Do **not** apply the formal writing voice; this is a working artifact, not prose for publication.
- Quote the transcript only when a decision hinges on exact wording.

### 4. Show the extracted action items first — do NOT auto-append
Display the **Action items** and **Open questions** to the user before writing them anywhere downstream. Transcript extraction can invent a "next step" nobody actually agreed to, so the user vets the list first. Ask: *"Append these action items to `_Tasks_for_the_AI.md` and log this meeting in the progress log?"*

### 5. On approval, append (not overwrite)
Once the user confirms (and after any edits they request):
- **Append** the vetted action items to the project's `_Tasks_for_the_AI.md`, under a dated heading like `## From meeting YYYY-MM-DD — [topic]`. Never overwrite existing tasks.
- Add a **one-line pointer** to the current/most-recent progress log in `progress_logs/`, e.g. `- Processed meeting [topic] (YYYY-MM-DD); summary in correspondence/meeting_notes/, N action items added to _Tasks_for_the_AI.md`.
- Confirm what was written and where.

## Notes
- The raw transcript stays in Dropbox (co-authors and AI can read it) but out of Git history.
- This skill never deletes the transcript; archival is the user's call.
- If the transcript spans multiple distinct topics/projects, ask whether to split the action items across more than one `_Tasks_for_the_AI.md`.
