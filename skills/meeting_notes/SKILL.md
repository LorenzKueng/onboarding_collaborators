---
name: meeting_notes
description: Summarize a meeting transcript (MS Teams, Fireflies, etc.) into a fixed-shape summary — overview, decisions, numbered action items with owners, open questions — then, after showing the extracted items, append the action items to the project's _Tasks_for_the_AI.md, drop a pointer in the current progress log, and (for co-author research meetings) create a Gmail draft with the to-dos grouped by person. Use when the user has a meeting recording/transcript to process into next steps.
argument-hint: "[path to transcript file] (optional — otherwise asks)"
---

# Meeting Notes — transcript → summary + next steps

Turn a raw meeting transcript into a durable summary and a vetted to-do list. Transcripts come from MS Teams, Fireflies, Otter, Zoom, or a pasted block of text.

## Run it one-shot: batch every approval up front

Approve everything at the **start** and let the skill run to completion without per-step interruptions. Do the read-only work first (locate + read the transcript, extract the items), then present a **single approval batch** and, once approved, run the rest one-shot. The batch must cover every decision and permission this run needs:

1. **Date, topic, and routing** — the date and short topic (→ filename), and whether this is a co-author research meeting (→ project repo + email) or an advising/one-to-one meeting (→ private folder, no email).
2. **What you'll write** — that you'll file the transcript, write the summary, append the action items to `_Tasks_for_the_AI.md`, and drop a progress-log pointer.
3. **The extracted action items and open questions** — shown in full so the user vets owners and wording before anything is written downstream (the Step 4 checkpoint, pulled forward).
4. **For co-author research meetings: the follow-up email** — the drafted email (or a tight preview), the recipient list, and any co-author emails still missing from `CLAUDE.md` (the Step 6 checkpoint, pulled forward).
5. **Any clarifying questions** — ask them all here, not piecemeal.

After approval, execute Steps 1–6 without stopping. Only pause mid-run if something material changes from what was approved — e.g. the transcript contradicts the assumed routing, or a load-bearing fact conflicts. The per-step "show and ask" checkpoints in Steps 1, 4, and 6 are satisfied by this up-front batch; don't re-ask for approvals already collected.

## Where files live

Per the project directory structure (`Project_setup.md`), meeting files live in **`correspondence/meeting_notes/`**, raw and summary side by side, dated:
- `correspondence/meeting_notes/YYYY-MM-DD_<short-topic>_transcript.<ext>` — raw export
- `correspondence/meeting_notes/YYYY-MM-DD_<short-topic>_summary.md` — what this skill writes

Raw transcripts are git-ignored (`correspondence/meeting_notes/*_transcript.*`); the summary is committed. If the project has no `correspondence/meeting_notes/` folder yet, create it.

## MS Teams: download the transcript first (manual step)

Teams does **not** save the transcript as a file. The recording (`.mp4`) syncs down via the channel's
`Recordings-<project>` OneDrive shortcut, but the transcript stays attached to the recording in Microsoft
Stream and has to be exported by hand. **After each Teams meeting, download the transcript:** in the
channel's recap post ("Meeting ... ended") click **Transcript**, then the **⋯** menu, then **Download**,
and choose **`.docx`**. It lands in your **Downloads** folder with a generic, timestamp-free name like
`Meeting in _<Channel>_ .docx`. Then tell Claude "process the latest meeting" and the skill picks it up
from Downloads, dates it, and files it (Step 1); you do not need to move or rename it yourself.

(A fully hands-off pull via the Microsoft Graph API needs tenant-admin consent, which is usually
unavailable at a university, so the manual download is the supported path.)

## Fireflies: download the transcript first (manual step)

Fireflies API access requires the Business plan; on Free/Pro there is no API key, so the supported path
is a manual export, like Teams. **After a Fireflies-recorded call, download the transcript:** open the
meeting, click **Download**, choose **`.docx` or Markdown** (keeps speaker labels; avoid PDF, and skip
`.srt`/`.vtt` here since they carry timestamps but not speaker names), and tick **"Remove Fireflies
Branding"** (strips the logo/marketing footer — cleaner file, no downside). Optionally also download the
Fireflies **summary** — it is used only as a cross-check against the transcript extraction, never as the
source of truth. Both files land in **Downloads** with cryptic names like
`Jul-13-02-31-PM-<hash>.md` and `... _summary.md`. Then tell Claude "process the latest meeting" and the
skill picks up the newest Fireflies export, dates it, files it, and (if present) files the summary as
`..._summary_Fireflies.md` for cross-checking — you do not rename anything by hand.

Fireflies speaker labels ("Speaker 1/2/3") are often mis-assigned. Treat any name→speaker mapping the
user gives as a **hint, not gospel**: confirm each speaker against conversational context (who owns which
data/model, who assigns tasks) and flag any swap before finalizing action-item owners.

## Steps

### 1. Locate the transcript
- If the user gave a path or pasted text, use it.
- **MS Teams transcript in Downloads (the usual case):** if no path is given, look in the user's
  **Downloads** folder for the newest `Meeting in *.docx` (the Teams export). Get the meeting date and
  topic from its first lines: the title line embeds the recording timestamp as
  `...-YYYYMMDD_HHMMSS-Meeting Recording` in **local** time (use this for the date); a human-readable date
  appears just below it but is in **UTC**, so it can land on the wrong day for meetings near midnight. If
  neither is present, fall back to the file's modified date. Then move and rename it to
  `correspondence/meeting_notes/YYYY-MM-DD_<short-topic>_transcript.docx`. Confirm the date and topic with
  the user before moving.
- Otherwise look in `correspondence/meeting_notes/` for a `*_transcript.*` without a matching
  `*_summary.md`, and confirm which one to process.
- For any other location, offer to move/copy it into `correspondence/meeting_notes/` with the dated
  naming convention first.

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
- **Clean up Downloads.** Files downloaded from Teams/Fireflies/etc. are **moved** (not copied) into
  `correspondence/meeting_notes/` during filing, so nothing is left behind in the user's **Downloads**
  folder. After filing, verify no source file for this meeting remains in Downloads (transcript and any
  auxiliary export such as the Fireflies summary); if a stray copy is still there, remove it. The user
  downloads everything to Downloads without renaming — the skill does the dating/renaming and the cleanup.

### 6. Draft the follow-up email to the participants

**Runs automatically for co-author research meetings. Never for advising / one-to-one meetings** — those summaries stay private. Skip it if you were the only participant.

Three rules that are easy to get wrong:

- **Build the email from the `_summary.md` file, not from the transcript.** The summary is the vetted artifact; the transcript is not. Two generators reading the same transcript will drift.
- **Run this only after Step 5.** The email publishes the task assignments, so the user must have vetted them first.
- **Apply the user's writing voice** to the email. This inverts the rule for the summary, which is explicitly an internal working artifact in terse notes register. The email goes out under the user's name.

**Recipients** come from the project's `CLAUDE.md` "Co-authors" section. If it has no addresses, ask for them and offer to add them. Some co-authors have more than one address; include all of them.

**Create the draft, never send it.** Use the Gmail MCP server's draft tool; the user reviews and sends. If the server is unavailable, fall back to writing `correspondence/YYYY-MM-DD_email-to-coauthors_draft.md` and say clearly that no Gmail draft was created.

**Template:**

```
Subject: [Project name] - to-dos from the [Month D] call

Hi [first names],

I ran our [Month D] call through Claude. It produced a summary and a to-do list[, and I
reconciled [Name]'s notes with the full transcript]. Everything is in our shared project
folder.

Where to find it:
- Summary (decisions + all to-dos): correspondence/meeting_notes/[YYYY-MM-DD]_[topic]_summary.md
- Running task list: _Tasks_for_the_AI.md, section "From meeting [YYYY-MM-DD]"
- Raw transcript: correspondence/meeting_notes/[YYYY-MM-DD]_[topic]_transcript.docx

Where we landed:
- [decision, compressed from the summary's Decisions section]

To-dos by person:

[Co-author A]:
1. [task]

Me:
1. [task]

Next meeting: [date]. Let me know if anything in the summary looks off, or if I
mis-assigned a task.

Best,
[Name]
```

Conventions for filling it in:

- **"To-dos by person" regroups the summary's numbered action items by their `[OWNER]` tag.** Every action item appears exactly once. Anything tagged `[unassigned]` goes under an "Unassigned" heading — never drop it silently, and never guess an owner.
- Items owned jointly go under the first owner with the co-owner named in the text.
- **Where we landed** compresses the Decisions section to the three or four a co-author needs. Preserve the user's own caveats; do not launder them into consensus.
- Reference files by **repo-relative path**, not attachments — co-authors share the project folder.
- Completed action items (`✅`) are omitted from the email.
- Show the drafted email in the chat and confirm the recipient list before creating the Gmail draft.

## Notes
- The raw transcript stays in the shared folder (co-authors and AI can read it) but out of Git history.
- This skill never deletes the transcript; archival is the user's call.
- If the transcript spans multiple distinct topics/projects, ask whether to split the action items across more than one `_Tasks_for_the_AI.md`.
- **The skill drafts email; it never sends it.** Sending is the user's call.
- If a co-author later emails their own notes on the same meeting, save them verbatim next to the summary as `YYYY-MM-DD_<topic>_<Name>s-notes.txt` and reconcile them into the summary. When the notes and the transcript disagree on a load-bearing fact, ask the user — do not average the two or pick by recency.
