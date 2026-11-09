---
name: grill-with-docs
description: Grilling session about a new project or feature that also builds its domain model, writing glossary and ADRs in ADR folder as decisions crystallise. The first step before /to-spec.
disable-model-invocation: true
argument-hint: <short description of the project or feature>
---
## Locations: 
every file and folder this skill reads or writes (the spec folder, glossary, ADR folder, architecture doc, standards, labels file) is listed under "Where things are" in CLAUDE.md. Look them up there; don't assume paths.

# Grill With Docs

Plan a new project or feature with the user through a grilling session, while building its domain model in `docs/`.

Call the Skill tool with `grilling` and with `domain-modeling`, and follow both:

- `grilling` drives the questions. The scope is the whole project or feature the user describes.
- `domain-modeling` keeps the language sharp and writes glossary and ADRs in ADR folder as terms and decisions crystallise.

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

1. Go over the whole session once:
- Project concepts that came up in the user's answers and aren't in the glossary yet: terms they introduced, things they defined while answering a question, or words whose meaning had to be pinned down. Only concepts specific to this project, not general programming terms. Propose them with a draft definition based on how the user described them, and add the ones the user confirms.
- Decisions that meet all three ADR criteria (hard to reverse, surprising without context, a real trade-off) and weren't recorded yet: list them with one line each on why. For each on the user wants, ask them to state the decision and reasons in their own words, then write the ADR. Skip whatever has nothing to add.
2. Offer to save the decisions to spec folder as <slug>-decisions.md`, so they
survive if the user continues in another session. Pick a short slug and
tell the user the path. Group by topic, and for each decision write:
- **Decision**: what was decided, in the user's words.
- **Why**: the reason the user gave, in one or two sentences. If they
  gave none, write "no reason given"; never invent one.
- **Rejected**: alternatives that were seriously considered, if any.
- **ADR**: a link to the ADR, if one was written for it.
Then add two short lists: **Open questions** (what is still undecided,
and why) and **Out of scope** (what the user explicitly ruled out).
3. List which glossary terms and ADRs were written during the session, so the user can review them with `git diff` and commit.
4. Point to the next step: `/to-spec`, in this same session if possible, or `/to-spec <spec-folder>/<slug>-decisions.md` later.
