---
name: to-spec
description: "Turn the grilling session (current conversation, or a saved decision summary) into a spec in spec folder. no interview, just synthesis of what has already been decided."
disable-model-invocation: true
---

This skill turns what has already been decided into a spec. Do NOT interview the user about the design; just synthesize what you already know.

The user is learning and writes all code themselves. The spec records **their** decisions. Never add design decisions they didn't make; if something important is undecided, list it under Open Questions instead of deciding it yourself.

## Locations 
every file and folder this skill reads or writes (the spec folder, glossary, ADR folder, architecture doc, standards, labels file) is listed under "Where things are" in CLAUDE.md. Look them up there; don't assume paths.

## Inputs

This skill normally runs right after `/grill-with-docs`, in the same session. Use the first source that applies:

1. **The current conversation**, when it contains a grilling session.
2. **A file the user passes as an argument**, e.g. `/to-spec docs/spec/task-tracker-decisions.md`: a saved decision summary from an earlier grilling.
3. If neither exists, tell the user to run `/grill-with-docs` first, and stop.

- In all cases, also read the glossary. 
- Also read the ADRs in ADR folder. Use the glossary vocabulary throughout the spec, and respect the ADRs.

### What to take from a grilling session

After `/grill-with-docs`, the conversation contains these parts. Use them as follows:

- **The confirmed decision summary** at the end of the grilling is the authoritative source. When it conflicts with something said earlier, the summary wins.
- **The rounds of questions and the user's answers** fill in the detail behind the summary: concrete examples, edge cases, reasons. If the user changed an answer later in the session, use the latest version.
- **Your own views during the grilling** are not decisions. Only include them where the user explicitly agreed. A view the user rejected or ignored stays out.
- **Questions the user answered with "I don't know" or left for later** go to Open Questions, not to a section as if they were decided.
- **Terms resolved during the session** are in the glossary files; use those exact terms.
- **ADRs written during the session** are in the ADR folder; reference them from Implementation Decisions instead of repeating their content.

Map the material to the spec sections:

| Spec section | Where it comes from |
|---|---|
| Problem Statement, Solution | The opening of the grilling: what the user wants to build and why |
| User Stories | Features, edge cases and error situations the user decided on |
| Implementation Decisions | Decisions about structure, storage and parts of the program, plus ADRs |
| Testing Decisions | Usually not covered by the grilling: settle it in step 2 below |
| Out of Scope | Everything the user explicitly ruled out or postponed |
| Open Questions | Undecided or "later" items, and gaps you notice while writing |

If a section has no material, don't fill it with your own ideas: write that it wasn't discussed, and add the gap to Open Questions.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. For a new project this may be nearly empty; that's fine.

2. Sketch the **seams** at which the feature will be tested. A seam is a place where you can test behaviour from the outside, without depending on internal details: for a CLI tool, often "run the command, check the output". Prefer existing seams to new ones, and the highest seam possible. The fewer seams, the better: ideally one.

   The first time, explain in one or two sentences what a seam is. Then ask the user where they think the seams should be, before giving your view. Settle this with the user before writing.

3. Write the spec using the template below, to the spec folder, as <slug>.md. Pick a short, descriptive slug and tell the user the path.

   Do not publish it to GitHub. The spec lives in the repo; the tickets made from it (with `/to-tickets`) go to GitHub.

4. Tell the user to review the spec and commit it. Mention that `/to-tickets <spec-folder>/<slug>.md` is the next step.

<spec-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A list of user stories, each with a stable ID. Each user story should be in the format of:

- **US-1**: As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
- **US-1**: As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

The IDs are how tickets refer to stories. When updating an existing spec, never renumber or reuse IDs: add new stories with the next free number, and mark a removed story as `(removed)` instead of deleting it.

Cover every aspect of the feature that was discussed, including edge cases and error situations. Don't invent stories for things that weren't discussed: put those under Open Questions.

## Implementation Decisions

The implementation decisions the user made. This can include:

- The modules that will be built/modified
- The interfaces of those modules
- Technical clarifications from the user
- Architectural decisions (link the ADR in ADR folder where one exists)
- Data or storage format
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly. Describe *what* was decided, never *how* to code it.

## Testing Decisions

The testing decisions that were made. Include:

- What makes a good test here (test external behavior at the seams, not implementation details)
- Which modules or seams will be tested
- Prior art for the tests (similar tests already in the codebase, if any)

## Out of Scope

What is explicitly out of scope for this spec. The explicit no-s are as valuable as the yes-s.

## Open Questions

Anything important that wasn't decided during the grilling. Leave these for the user; don't answer them.

## Further Notes

Any further notes about the feature.

</spec-template>
