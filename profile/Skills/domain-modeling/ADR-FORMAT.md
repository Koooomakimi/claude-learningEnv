# Locations: 
every file and folder this skill reads or writes (the spec folder, glossary, ADR folder, architecture doc, standards, labels file) is listed under "Where things are" in CLAUDE.md. Look them up there; don't assume paths.

# ADR Format

ADRs (Architecture Decision Records) live in ADR folder and use sequential numbering: `0001-slug.md`, `0002-slug.md`, etc. In a multi-context project, context-specific decisions go in `<ADR folder>/<context>/`, with their own numbering.

Create the ADR folder directory lazily: only when the first ADR is needed.

## Template

```md
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

That's it. An ADR can be a single paragraph. The value is in recording *that* a decision was made and *why*, not in filling out sections.

Write the "why" from the reasons the user gave, in their words where possible. Never add reasons they didn't state.

## Optional sections

Only include these when they add genuine value. Most ADRs won't need them.

- **Status** frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`): useful when decisions are revisited
- **Considered Options**: only when the rejected alternatives are worth remembering
- **Consequences**: only when non-obvious downstream effects need to be called out

## Numbering

Scan ADR folder (or `<ADR folder>/<context>/`) for the highest existing number and increment by one.

## When to offer an ADR

All three of these must be true:

1. **Hard to reverse**: the cost of changing your mind later is meaningful
2. **Surprising without context**: a future reader will look at the code and wonder "why on earth did they do it this way?"
3. **The result of a real trade-off**: there were genuine alternatives and you picked one for specific reasons

If a decision is easy to reverse, skip it: you'll just reverse it. If it's not surprising, nobody will wonder why. If there was no real alternative, there's nothing to record beyond "we did the obvious thing."

### What qualifies

- **Architectural shape.** "The app is a CLI first; a GUI comes later on top of the same core." "Data is stored in one SQLite file, not in separate JSON files."
- **Integration patterns between parts.** "The parser and the storage layer only talk through plain data objects, never through each other's internals."
- **Technology choices that carry lock-in.** Database, framework, storage format, deployment target. Not every library: just the ones that would be painful to swap out.
- **Boundary and scope decisions.** "Recurring tasks are out of scope for version 1." The explicit no-s are as valuable as the yes-s.
- **Deliberate deviations from the obvious path.** "We write SQL by hand instead of using an ORM, to learn SQL." Anything where a reasonable reader would assume the opposite. These stop a future reader (including future you) from "fixing" something that was deliberate.
- **Constraints not visible in the code.** "It must run without internet access." "It must work on the school's Linux machines."
- **Rejected alternatives when the rejection is non-obvious.** If you considered a web app and picked a CLI for specific reasons, record it; otherwise you'll reconsider it again in a month.

In a learning project, "because I want to learn X" is a legitimate reason for a decision, and worth recording: it explains a choice that would otherwise look odd.
