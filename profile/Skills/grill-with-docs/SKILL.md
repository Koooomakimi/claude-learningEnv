---
name: grill-with-docs
description: Grilling session about a new project or feature that also builds its domain model, writing docs/GLOSSARY.md and ADRs in docs/adr/ as decisions crystallise. The first step before /to-spec.
disable-model-invocation: true
argument-hint: <short description of the project or feature>
---

# Grill With Docs

Plan a new project or feature with the user through a grilling session, while building its domain model in `docs/`.

Call the Skill tool with `grilling` and with `domain-modeling`, and follow both:

- `grilling` drives the questions. The scope is the whole project or feature the user describes.
- `domain-modeling` keeps the language sharp and writes `docs/GLOSSARY.md` and ADRs in `docs/adr/` as terms and decisions crystallise.

## Cover what the spec will need

This session is the input for `/to-spec`. Make sure the design tree covers:

- the problem, and who has it;
- the main features;
- edge cases and error situations;
- what is out of scope;
- how data is stored;
- the main parts of the program;
- how the result will be tested.

Don't force decisions the user isn't ready to make. "I don't know yet" or "decide later" is a valid outcome: note it as an open question.

## Finishing

When the frontier is empty, `grilling` ends with a decision summary in the user's words. After the user confirms it:

1. Offer to save the summary to `docs/spec/<slug>-decisions.md`, so it survives if the user continues in another session. Pick a short slug and tell the user the path.
2. List which glossary terms and ADRs were written during the session, so the user can review them with `git diff` and commit.
3. Point to the next step: `/to-spec`, in this same session if possible, or `/to-spec docs/spec/<slug>-decisions.md` later.
