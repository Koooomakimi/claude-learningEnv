---
name: codebase-review
description: Review the whole codebase along two axes: Standards (does all code follow the user's standards, glossary and ADRs?) and Architecture (is the structure itself sound?). Use once per milestone, not per ticket; per-ticket reviews are /code-review.
disable-model-invocation: true
argument-hint: "[part to limit the review to]"
---

## Locations: 
every file and folder this skill reads or writes (the spec folder, glossary, ADR folder, architecture doc, standards, labels file) is listed under "Where things are" in CLAUDE.md. Look them up there; don't assume paths.

# Codebase Review

Review the whole codebase, not a diff, along two axes:

- **Standards**: does the code, everywhere, follow the user's standards, the glossary and the ADRs?
- **Architecture**: is the structure itself sound: the parts, their responsibilities, and how they connect?

Both axes run as sub-agents with fresh context windows, so neither pollutes the other and no single context has to hold the whole codebase. This skill then aggregates their findings.

The user writes all code themselves and is learning. Never fix the code, not in the report and not in the sub-agents: give hints, not solutions. Never edit the architecture either; if it's out of date, say so and point to `/update-architecture`.

If the user passes a part name as an argument, limit both axes to that part and its connections.

## Process

### 1. Check that a review makes sense

If the project has only a few files, say a codebase review isn't worth it yet (`/code-review` covers it), and stop unless the user insists.

### 2. Ask the user first

Before looking at anything, ask: "Which parts of your code do you think are weakest, and why? Name one to three." Wait for the answer. At the end, the report compares the user's assessment with the findings: recognising weak spots in your own code is the skill being trained.

### 3. Gather the map and the standards

Collect from CLAUDE.md: personal standards, project standards, review guidelines named in the project CLAUDE.md, the glossary, the ADR folder”

Decide the parts to review: one per row of the Parts table in ARCHITECTURE.md, or per main folder without it. Skip dependency and build folders.

On top of the documented standards, the Standards axis always carries the smell baseline below: a fixed set of Fowler code smells (Refactoring, ch.3). Two rules bind it:

- **Documented standards override.** A documented standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation. Skip anything tooling already enforces.

Each smell reads what it is → how to fix:

- **Mysterious Name**: a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code**: the same logic shape appears in more than one place. → extract the shared shape, call it from both.
- **Feature Envy**: a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps**: the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession**: a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches**: the same switch/if-cascade on the same type recurs. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery**: one logical change would force scattered edits across many files. → gather what changes together into one module.
- **Divergent Change**: one file or module changes for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality**: abstraction, parameters, or hooks for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains**: long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man**: a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest**: a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

### 4. Spawn the sub-agents in parallel

Issue all sub-agent calls together, in the foreground. Sub-agents don't see CLAUDE.md: give each one the concrete paths of every file it needs.

Every sub-agent brief starts with: "The user is learning and writes all code themselves. Never write corrected code. For every finding, give:

- Severity: blocker / should-fix / nit
- Location: file:line, or the part name for structural findings
- What and why: the problem, and the consequence it has in *this* code
- Hint: point to the concept and the direction of a fix, no corrected code
- Concept: one short tag (e.g. naming, error-handling, testing, modularity)"

**Standards sub-agents: one per part.** Each gets the part's files, the standards-source files, and the smell baseline pasted in full. Brief, after the shared start:

"Report for this part: (a) violations of a documented standard: cite the file and rule; (b) names that don't match the glossary; (c) anything that goes against an ADR: cite the ADR; (d) baseline smells: name them and quote the code. Distinguish hard violations from judgement calls. Report a recurring issue once, as a pattern with all locations. Mention one thing that's well done. Return at most your 5 most important findings, ranked. Under 400 words."

**Architecture sub-agent: one, for the whole codebase.** It gets `docs/ARCHITECTURE.md` (if any), the ADRs, the spec's Testing Decisions, and the folder structure. It reads code only where it needs to see how parts connect: imports, interfaces, entry points. Brief, after the shared start:

"Assess the structure, not line-level style. Check:

- Responsibilities: does each part have one clear job? Is any job split across parts, or are several jobs crammed into one?
- Dependencies: which part depends on which? Are there cycles? Does core logic depend on details like the UI, storage or network, instead of the other way around?
- Depth: does each part hide a lot behind a small interface (deep), or expose about as much as it does (shallow)?
- Boundaries: do parts reach into each other's internals instead of going through an interface?
- Testability: can each part be tested at the seams the spec names, without dragging in the rest?
- Fit: is the structure right-sized for this project, neither a ball of mud nor layers it doesn't need?
- Decisions: does the structure respect the ADRs?
- The map: where does ARCHITECTURE.md differ from the code? List the differences; don't judge which is right.

Explain each structural finding with the consequence it will have as the project grows (e.g. 'adding a second storage type would mean editing three parts'). Mention one structural choice that's good, and why. Return at most your 5 most important findings, ranked. Under 600 words."

### 5. Aggregate

Present the reports under two headings, `## Architecture` first (structure matters most at this level), then `## Standards`, with the Standards findings grouped per part. Do not merge findings across the two axes.

Cap the total: keep the 5 architecture findings and the 10 most important standards findings across all parts. Mention how many lower-ranked findings were left out.

If ARCHITECTURE.md differs from the code, list the differences under `### Map out of date` and recommend `/update-architecture`.

End with a one-line summary per axis: number of findings and the worst one.

### 6. Save the report

Write the full report to docs/reviews/ as `codebase-<YYYY-MM-DD>.md`. Start it with a short **Overview**: per axis, the
number of findings and the worst one. Then the Architecture, Standards and
Learning sections as presented, and the list of follow-ups that were created
as issues or added to the backlog file.

If an earlier `codebase-*.md` report exists, compare with the most recent one
before writing, and add a **Since last review** section after the Overview:
which earlier findings are resolved, which are still open, and which are new.
Never edit or delete earlier reports.

Tell the user the path.

### 7. Learning

Add a `## Learning` section:

- **Your assessment vs the review**: compare the weak spots the user named in step 2 with the findings. Which did they spot, which did they miss, and were any of their concerns unfounded?
- **Main takeaway**: the single most important lesson, in one sentence.
- **Recurring concepts**: concept tags that appear in several findings. These are worth practising, or adding as a rule to their coding standards.
- **Follow-up issues**: propose issues for the findings worth fixing, most important first. Label them as the labels file listed in CLAUDE.md prescribes for code-review follow-ups. Ask before creating any; create approved ones with `gh issue create`.

Never fix the code yourself, not even in the report.