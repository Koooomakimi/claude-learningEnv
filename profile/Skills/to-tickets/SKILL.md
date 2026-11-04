---
name: to-tickets
description: Break a spec in docs/spec/ into tracer-bullet tickets on GitHub, each declaring its blocking edges and the user stories it covers. Can be re-run after the spec changes; then it only proposes tickets for what isn't covered yet.
disable-model-invocation: true
---

# To Tickets

Break a spec into a set of **tickets**: tracer-bullet vertical slices, each declaring the tickets that **block** it and the user stories it **covers**.

The user is learning and writes all code themselves. Tickets describe **what** must work and how to verify it, never **how** to build it. The issue tracker is GitHub, used via the `gh` CLI (see CLAUDE.md).

## Process

### 1. Gather context

The user passes a spec path as an argument, e.g. `/to-tickets docs/spec/task-tracker.md`. If they don't, list `docs/spec/` and ask which spec to use.

Read:

- the spec, in full;
- the glossary: `docs/GLOSSARY.md`, or, if `docs/GLOSSARY-MAP.md` exists, the map and the context glossaries it points to in `docs/glossary/`;
- the ADRs in `docs/adr/`.

Use the glossary vocabulary in all ticket titles and descriptions, and respect the ADRs.

### 2. Check what already exists

Every ticket made from a spec carries the label `spec:<slug>`, where `<slug>` is the spec's file name without `.md`. Fetch all of them, open and closed:

```
gh issue list --label "spec:<slug>" --state all --limit 200 --json number,title,state,body
```

From the **Covers** section of each existing ticket, build a coverage map: which user stories (US-1, US-2, …) are already covered, by which ticket, and whether that ticket is open or closed.

Then compare the spec against that map:

- **Uncovered stories**: user stories no ticket covers yet. These are the only ones that get new tickets.
- **Changed stories**: covered stories whose text or acceptance-relevant details changed in the spec since the ticket was written.
  - Covered by an **open** ticket → propose an edit to that ticket.
  - Covered by a **closed** ticket → propose a new follow-up ticket for the difference only.
- **Removed stories**: covered stories that no longer appear in the spec → point them out; never close or delete a ticket yourself.

If nothing is uncovered, changed or removed, tell the user everything is already covered, and stop.

Never create a ticket for a story that is already covered.

### 3. Check the codebase (only where needed)

Skip this step if the project has little or no code yet.

Otherwise, use `docs/ARCHITECTURE.md` and the closed tickets as your map of
what exists. If there's no ARCHITECTURE.md yet, use the folder structure and
the closed tickets, and suggest running `/update-architecture` afterwards.
Only open files that the uncovered or changed stories will touch. Don't
survey the whole codebase.

If one of those parts would be much easier to extend after a small
restructuring first ("make the change easy, then make the easy change"),
propose that as its own ticket, first in line, and explain in one sentence
why it helps.

### 4. Draft vertical slices

Break the uncovered work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every part it needs (data, logic, interface, tests): vertical, NOT a horizontal slice of one layer.
- A completed slice is demoable or verifiable on its own.
- Each slice is one to a few sessions of work for the user, and introduces at most one or two concepts that are new to them.
- Order slices from simple to harder, so each builds on what the user just learned.
- Any prefactoring comes first.

</vertical-slice-rules>

Give each ticket its **blocking edges**: the other tickets (new or existing) that must complete before it can start. A ticket with no blockers can start immediately.

If the spec has **Open Questions** that a slice depends on, don't guess the answer. Either leave that slice out and say so, or propose a separate "Decide: …" ticket that blocks it.

### 5. Quiz the user

Present the proposed changes as a numbered list, in three groups:

- **New tickets**: title, blocked by, covers (story IDs), what it delivers.
- **Edits to open tickets**: ticket number, and what changes.
- **Follow-ups and removals**: follow-up tickets for closed work, and stories that disappeared from the spec.

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Is the order right for learning: does each ticket only need concepts from earlier ones?
- Are the blocking edges correct: does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves.

### 6. Publish to GitHub

Check the labels first with `gh label list`. Use the label names and rules
from the labels file listed in CLAUDE.md. If a label it prescribes doesn't
exist in the repo yet, propose creating it.

Then, after the user's approval:

- Create new tickets with `gh issue create`, in dependency order (blockers first), so later tickets can reference real issue numbers in **Blocked by**.
- Apply the labels the labels file prescribes for tickets made from a spec, and for "Decide: …" tickets.
- Apply approved edits to open tickets with `gh issue edit`.

Each `gh issue create` and `gh issue edit` asks the user for permission; that is intended.

Never close, delete or reopen any ticket.

<issue-template>

## Spec

`docs/spec/<slug>.md`

## Covers

- US-<n>: <short title of the story>
- US-<n>: <short title of the story>

## What to build

The end-to-end behaviour this ticket makes work, from the user's perspective, not a layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Concepts

What the user will learn or need for this ticket, e.g. "reading and writing files", "input validation".

## To look up

Documentation pages or search terms that help. No code.

## Blocked by

- #<number> <title>, or "None (can start immediately)".

</issue-template>

Avoid specific file paths, code snippets and implementation steps: they go stale fast, and working them out is the user's job.

### 7. Wrap up

List the tickets you created or edited, and tell the user which ticket(s) can start now. Suggest naming the branch after the ticket number, e.g. `12-<slug>`, so `/code-review` can find it.
