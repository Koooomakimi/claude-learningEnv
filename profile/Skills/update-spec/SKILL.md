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

## Locations: 
every file and folder this skill reads or writes (the spec folder, glossary, ADR folder, architecture doc, standards, labels file) is listed under "Where things are" in CLAUDE.md. Look them up there; don't assume paths.

## Process

### 1. Gather context

If no spec path was given, list spec folder and ask which spec to update.

Read:

- the spec, in full;
- the glossary;
- the ADRs in the ADR folder;
- the existing tickets for this spec, to know what is already planned or built:

  ```
  gh issue list --label "spec:<slug>" --state all --limit 200 --json number,title,state,body
  ```

  where `<slug>` is the spec's file name without `.md`. Use each ticket's **Covers** section to see which user stories it covers.

### 2. Work it out with the user

Call the Skill tool with `grilling` and follow its rules for asking questions: the user answers first, then you give your view, at most 3 questions per round.

**Keep the grilling scoped.** This is an update, not a new design session. The scope for `grilling` is the open question or the change, not the whole project. These scope rules take precedence over the defaults of both `grilling` and `domain-modeling`.

- Only ask about branches the question or change actually touches. Everything already in the spec counts as settled; don't reopen it, unless the new answer contradicts it. Then point out the contradiction and ask which one holds.
- Before asking, check whether the spec, glossary or ADRs already answer it. If so, don't ask.
- A question is done as soon as the answer is precise enough to write into the spec. Don't dig deeper than the spec needs; implementation details belong to the user's own work on the tickets.
- Aim for one round per open question. Go further only if the answer raises a genuinely new decision.
- The user can say "skip", "leave it open" or "enough" at any time. Then stop asking about that question and move on.

**Open questions mode:** take the questions from the spec's Open Questions section, most fundamental first. For each one, if it turns out to be bigger than it looked, grill on it until it's settled. The user may also decide to leave a question open: that's a valid outcome.

**Change mode:** grill on the change itself: what exactly changes, which user stories it touches, what's now in or out of scope, and any new edge cases.

In both modes, whenever an answer affects a user story that is covered by a **closed** ticket (work already built), say so: "US-3 is already built in #12; changing it means follow-up work." Let the user decide whether that's worth it.

When terms or decisions come up, also call the Skill tool with `domain-modeling`, so the glossary stays consistent and qualifying decisions get an ADR.

### 3. Second look: glossary and ADRs

Before proposing anything, go over this session once more, limited to the questions and changes worked on in it:

- **Glossary**: project concepts that came up in the user's answers and aren't in the glossary yet: terms they introduced, things they defined while answering, or words whose meaning had to be pinned down. Also existing entries the answers changed the meaning of. Only concepts specific to this project, not general programming terms. Draft each definition from how the user described it.
- **ADRs**: decisions made in this session that meet all three ADR criteria (hard to reverse, surprising without context, a real trade-off) and aren't recorded yet. For each candidate, give one line on why it qualifies, and ask the user to state the decision and reasons in their own words. Also flag an existing ADR that a decision in this session contradicts: it may need to be superseded.

Skip whatever has nothing to add.

### 4. Propose the changes

Before writing, summarise the changes as a list: per spec section, what's added, changed, removed, and which open questions are resolved; plus the proposed glossary entries and ADRs from step 3. Ask the user to confirm.

### 5. Apply the changes

Edit the spec in place, following these rules:

- **User story IDs are stable.** Never renumber or reuse an ID. A new story gets the next free number (one higher than the highest ID ever used, including removed ones).
- **Changed story:** edit its text, keep its ID.
- **Removed story:** keep the line, mark it `(removed)` and add the reason in a few words. Don't delete it.
- **Resolved open question:** put the decision in the section it belongs to (User Stories, Implementation Decisions, Testing Decisions or Out of Scope), then remove the question from Open Questions.
- **New open questions** discovered along the way: add them to Open Questions.
- **Decisions the user didn't make** never go into the spec. If something is still undecided, it goes to Open Questions.
- No file paths, code snippets or implementation steps, same as in `/to-spec`.

Do not edit or create GitHub tickets; that's `/to-tickets`' job.

### 6. Wrap up

Tell the user:

- which files changed (the spec, and possibly the glossary or an ADR), so they can review with `git diff` and commit;
- which user stories are new, changed or removed, with their IDs;
- which existing tickets are affected (open tickets whose stories changed, closed tickets that now need follow-up);
- that `/to-tickets <spec-folder>/<slug>.md` will pick up exactly that difference.
