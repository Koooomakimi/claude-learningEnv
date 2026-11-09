---
name: update-architecture
description: Create or update docs/ARCHITECTURE.md, the map of how the project's code is built right now. The user describes the architecture first; you check it against the code. Incremental by default (only what changed since the doc was last committed), or a full check with "full".
disable-model-invocation: true
argument-hint: [full]
---

# Update Architecture

Keep `docs/ARCHITECTURE.md` an accurate map of the code **as it is now**: the main parts, what each is responsible for, how they connect, and where to find them.

It is not a spec (what will be built), not a glossary (what things are called) and not an ADR (why something was decided). Link to those instead of repeating them.

The user is learning. Describing their own architecture is the exercise, so **the user describes first, you check**. Never write a description of the code the user hasn't confirmed. You may only write inside `docs/`; the user reviews and commits.

## Locations: 
every file and folder this skill reads or writes (the spec folder, glossary, ADR folder, architecture doc, standards, labels file) is listed under "Where things are" in CLAUDE.md. Look them up there; don't assume paths.

## Pick the mode

- the architecture doc doesn't exist → **Create**.
- The user passed `full` → **Full check**.
- Otherwise → **Incremental**.

If the project has only a few files and no real separate parts yet, say that an architecture doc isn't worth it yet, and stop unless the user insists.

## Create

1. Ask the user to describe their architecture in their own words: the main parts, what each does, how they talk to each other, where the data lives. Rough is fine. Wait for it.
2. Survey the code yourself: the folders and main files. Skip dependency and build folders. In a larger project, dispatch an Explore sub-agent for the survey and use its summary, to keep this conversation small.
3. Compare the user's description with the code, and report per point: what matches, what is missing from their description, and what they described differently from how the code actually works. Ask about each difference; don't decide it yourself. A difference can mean the description is wrong, or the code is: let the user say which.
4. Once settled, write the architecture doc with the template below, based on the user's description, corrected only where they agreed.

## Incremental (default)

The existing doc is your map of everything that didn't change. Don't survey the codebase: trust the doc for unchanged parts, and only open files that changed.

1. Read the architecture doc in full.

2. Find the last commit that touched the doc:

   ```
   git log -1 --format=%H -- <architecture doc path>   
   ```

3. List what changed in the code since then:

   ```
   git diff --stat <that commit>..HEAD -- . ':!docs'
   ```

   If nothing changed, say the doc is up to date, and stop.

4. Ask the user first: "What changed in the structure since the last update?" Then look only at the changed files that could affect the map (new parts, moved responsibilities, new connections, new data). Ignore changes inside a part that don't change what it does or how it connects.
5. Report what the user's answer and the code agree on, and what they missed. Ask about each difference.
6. Propose the exact edits to the doc, per section, and apply them once the user confirms. Change only what changed; every other line stays.

## Full check

Use once per milestone, or when the doc and the code may have drifted apart.

1. Read the architecture doc. Ask the user if they know of anything that's out of date.
2. Survey the whole codebase with an Explore sub-agent, asking it to compare the code with the doc section by section.
3. Report: what's still accurate, what's outdated, what's missing. Ask about each difference.
4. Propose the edits per section and apply them once the user confirms.

## Template

Keep it short: a map, not a manual. Aim for under 100 lines. Use the glossary's terms. No function signatures, code snippets or step-by-step logic: they go stale fast.

```md
# Architecture

{1-3 sentences: what the program is and its overall shape, e.g. "A CLI that reads commands, applies them to a task list, and saves the list to a JSON file."}

## Parts

| Part | Responsibility | Where |
|---|---|---|
| {name, glossary term} | {what it does, one sentence} | {folder or main file} |

## How they connect

{The main flows, one numbered list per flow, e.g. how one command travels through the parts. Who calls whom, what passes between them.}

## Data

{Where data lives, in what format, and which part owns it.}

## Entry points

{How the program starts and where tests live.}

## Decisions

{Links to the ADRs in ADR folder that explain the shape above.}
```

## Wrap up

Tell the user which sections changed, so they can review with `git diff` and commit. Committing matters: incremental mode measures "what changed" from the last commit of this file.
