---
name: update-spec
description: Update an existing spec in docs/spec/, either by working through its Open Questions with the user or by applying a change the user describes, while keeping user story IDs stable so /to-tickets can pick up the difference.
disable-model-invocation: true
argument-hint: <spec path> [change to make]
---

# Update Spec

Update an existing spec in `docs/spec/`. Two modes:

- **Open questions**: the user passes only a spec path, e.g. `/update-spec docs/spec/task-tracker.md`. Work through the spec's Open Questions with the user.
- **A change**: the user passes a spec path plus a description, e.g. `/update-spec docs/spec/task-tracker.md add export to CSV`. Work out that change with the user and apply it.

The user is learning and writes all code themselves. The spec records **their** decisions. Never add design decisions they didn't make. You may only write inside `docs/`, and you can't commit: the user reviews and commits.

## Process

### 1. Gather context

If no spec path was given, list `docs/spec/` and ask which spec to update.

Read:

- the spec, in full;
- the glossary: `docs/GLOSSARY.md`, or, if `docs/GLOSSARY-MAP.md` exists, the map and the context glossaries it points to in `docs/glossary/`;
- the ADRs in `docs/adr/`;
- the existing tickets for this spec, to know what is already planned or built:

  ```
  gh issue list --label "spec:<slug>" --state all --limit 200 --json number,title,state,body
  ```

  where `<slug>` is the spec's file name without `.md`. Use each ticket's **Covers** section to see which user stories it covers.

### 2. Work it out with the user

Call the Skill tool with `grilling` and follow its rules for asking questions: the user answers first, then you give your view, at most 3 questions per round.

**Keep the grilling scoped.** This is an update, not a new design session. The scope for `grilling` is the open question or the change, not the whole project. These scope rules take precedence over grilling's default of visiting the whole design tree:

- Only ask about branches the question or change actually touches. Everything already in the spec counts as settled; don't reopen it, unless the new answer contradicts it. Then point out the contradiction and ask which one holds.
- Before asking, check whether the spec, glossary or ADRs already answer it. If so, don't ask.
- A question is done as soon as the answer is precise enough to write into the spec. Don't dig deeper than the spec needs; implementation details belong to the user's own work on the tickets.
- Aim for one round per open question. Go further only if the answer raises a genuinely new decision.
- The user can say "skip", "leave it open" or "enough" at any time. Then stop asking about that question and move on.

**Open questions mode:** take the questions from the spec's Open Questions section, most fundamental first. For each one, if it turns out to be bigger than it looked, grill on it until it's settled. The user may also decide to leave a question open: that's a valid outcome.

**Change mode:** grill on the change itself: what exactly changes, which user stories it touches, what's now in or out of scope, and any new edge cases.

In both modes, whenever an answer affects a user story that is covered by a **closed** ticket (work already built), say so: "US-3 is already built in #12; changing it means follow-up work." Let the user decide whether that's worth it.

When terms or decisions come up, also call the Skill tool with `domain-modeling`, so the glossary stays consistent and qualifying decisions get an ADR.

### 3. Propose the changes

Before writing, summarise the changes to the spec as a list, per section: what's added, changed, removed, and which open questions are resolved. Ask the user to confirm.

### 4. Apply the changes

Edit the spec in place, following these rules:

- **User story IDs are stable.** Never renumber or reuse an ID. A new story gets the next free number (one higher than the highest ID ever used, including removed ones).
- **Changed story:** edit its text, keep its ID.
- **Removed story:** keep the line, mark it `(removed)` and add the reason in a few words. Don't delete it.
- **Resolved open question:** put the decision in the section it belongs to (User Stories, Implementation Decisions, Testing Decisions or Out of Scope), then remove the question from Open Questions.
- **New open questions** discovered along the way: add them to Open Questions.
- **Decisions the user didn't make** never go into the spec. If something is still undecided, it goes to Open Questions.
- No file paths, code snippets or implementation steps, same as in `/to-spec`.

Do not edit or create GitHub tickets; that's `/to-tickets`' job.

### 5. Wrap up

Tell the user:

- which files changed (the spec, and possibly the glossary or an ADR), so they can review with `git diff` and commit;
- which user stories are new, changed or removed, with their IDs;
- which existing tickets are affected (open tickets whose stories changed, closed tickets that now need follow-up);
- that `/to-tickets docs/spec/<slug>.md` will pick up exactly that difference.
