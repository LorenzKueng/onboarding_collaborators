<!--
    This is a template for the **_Tasks_for_the_AI.md** file that goes into a project directory (projectX/).

    Purpose: break a single step from MEMORY.md (the strategic plan) into concrete,
    self-contained instructions the AI can execute. This is the AI's "short-term memory."

    How to use:
    - One step from MEMORY.md → one numbered section here
    - Mark tasks done with ✅ as you go (so the AI sees what's already complete)
    - Add a "Background" subsection with everything the AI would need to know but cannot infer:
      paths, co-author names, repo URLs, prior decisions, manual steps, file naming quirks
    - When a task requires back-and-forth with a co-author, keep the questions and answers here
      so the AI sees the full thread the next time the file is read
    - Once a step is fully done, you can either delete the section or archive it at the bottom
-->

# Tasks to give to the AI (Claude or Codex)

## 1. [Short title of the step from MEMORY.md]

**Background**

[A few sentences of context the AI needs but cannot derive from the code:
- Project name, co-authors, their roles
- Where things live (project directory, Overleaf folder, GitHub repo)
- Any prior state worth knowing (e.g., "an old version of the directory still exists at X as a backup")
- Manual steps the AI cannot see (e.g., "Co-author X manually toggled a setting in the spec")]

**Tasks**

1. [First concrete task — be specific: paths, file names, expected output]
2. [Second task] In particular:
    - [Subtask 2a]
    - [Subtask 2b]
3. [Third task]
4. ...

---

### [Co-author]'s answers to AI questions

Use this section when a task generates questions the AI needs a co-author to answer.
Keep both the question and the answer here, so the next session has full context.

#### Answer to Q1

**[Co-author]:** [their answer]

**[You]:** [follow-up or clarification, if any]

**[Co-author]:** [their reply]

#### Answer to Q2

**[Co-author]:**

*Instructions for the AI:*

[Sometimes the answer itself becomes a mini-spec for the AI to implement.
Put the instructions here in the form the AI should consume them.]

---

## 2. [Next step from MEMORY.md]

**Background**

...

**Tasks**

1. ...
2. ...

---

## Archive (completed steps)

[Optional: move fully-done sections here once you no longer need the AI to see them,
rather than deleting, in case you need to refer back.]
