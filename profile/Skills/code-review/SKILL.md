---
name: code-review
description: Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes: Standards (does the code follow the user's coding standards?) and Spec (does the code match the ticket and its spec?). Runs both reviews in parallel sub-agents, reports them side by side, and ends with a learning section. Use when the user wants to review a branch, work-in-progress changes, or asks to "review since X".
argument-hint: '[fixed point, e.g. main] [ticket, e.g. #12]'
---

Two-axis review of the diff between HEAD and a fixed point:

- **Standards**: does the code conform to the user's coding standards?
- **Spec**: does the code faithfully implement the ticket, and the spec it comes from?

Both axes run as parallel sub-agents so they don't pollute each other's context, then this skill aggregates their findings. Start every sub-agent with a fresh context window.

The user writes all code themselves and is learning. Never fix the code, not in the report and not in the sub-agents: give hints, not solutions.

The issue tracker is GitHub, used via the `gh` CLI (see CLAUDE.md).

## Locations: 
every file and folder this skill reads or writes (the spec folder, glossary, ADR folder, architecture doc, standards, labels file) is listed under "Where things are" in CLAUDE.md. Look them up there; don't assume paths.

## Process

### 1. Pin the fixed point

Whatever the user said is the fixed point (a commit SHA, branch name, tag, main, HEAD~5, etc.). If they didn't specify one, propose `main` and confirm.

Capture the diff command once: `git diff <fixed-point>...HEAD` (three-dot, so the comparison is against the merge-base). Also note the list of commits via `git log <fixed-point>..HEAD --oneline`.

Before going further, confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the diff is non-empty. A bad ref or empty diff should fail here, not inside two parallel sub-agents.

### 2. Identify the spec source

Find the ticket, in this order:

1. An issue number the user passed as an argument (e.g. `/code-review main #12`).
2. Issue references in the commit messages (#123, Closes #45, etc.) or an issue number in the branch name (e.g. `12-add-task`).

Fetch the ticket with `gh issue view <number>`.

If the ticket has a **Spec** section, read that spec file (you can find this spec file by looking at the "where are things" section in the CLAUDE.md file), and focus on the user stories listed under the ticket's **Covers** section. The ticket's acceptance criteria are the main yardstick; the spec gives the context and the why.

If no ticket is found, ask the user which issue it is. If they say there isn't one, the **Spec** sub-agent will skip and report "no spec available".

### 3. Identify the standards sources

Collect from claude.md every file that documents how code should be written:
personal standards, project standards, review guidelines named in the project CLAUDE.md, the glossary, the ADR folder”
On top of these, the Standards axis always carries the smell baseline below: a fixed set of Fowler code smells (Refactoring, ch.3) that applies even when nothing is documented. Two rules bind it:

- **Documented standards override.** A documented standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation. Like any standard here, skip anything tooling already enforces.

Each smell reads what it is → how to fix; match it against the diff:

- **Mysterious Name**: a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code**: the same logic shape appears in more than one hunk or file in the change. → extract the shared shape, call it from both.
- **Feature Envy**: a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps**: the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession**: a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches**: the same switch/if-cascade on the same type recurs across the change. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery**: one logical change forces scattered edits across many files in the diff. → gather what changes together into one module.
- **Divergent Change**: one file or module is edited for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality**: abstraction, parameters, or hooks added for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains**: long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man**: a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest**: a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

### 4. Spawn both sub-agents in parallel

Issue both sub-agent calls together, in the foreground, and aggregate the reports they return. 
Sub-agents don't see CLAUDE.md: give each one the concrete paths of every file it needs.

**Standards sub-agent** prompt should include:

- The full diff command and commit list.
- The list of standards-source files you found in step 3, plus the smell baseline from step 3 pasted in full (the sub-agent has no other access to it).
- The brief:

  "The user is learning and writes all code themselves. Report, per file/hunk where relevant, (a) every place the diff violates a documented standard: cite the standard (file + the rule); (b) names that don't match the glossary; (c) anything that goes against an ADR (as defined in /docs/adr/): cite the ADR; and (d) any baseline smell you spot: name it and quote the hunk. Distinguish hard violations from judgement calls: documented-standard breaches can be hard, but baseline smells are always judgement calls, and a documented standard overrides the baseline. Skip anything tooling enforces.

  For every finding, give:
  - Severity: blocker / should-fix / nit
  - Location: file:line
  - What and why: the problem, and the consequence it has in *this* code (not just the rule's name)
  - Hint: point to the concept and the direction of a fix. No corrected code; at most a one-line fragment if the hint is meaningless without it.
  - Concept: one short tag (e.g. naming, error-handling, testing, modularity)

  Also:
  - For each smell, explain in one sentence why it hurts in this specific code, so the user learns to recognise it.
  - Mention 1-2 things that are well done, with location.
  - If a finding is mechanical (formatting, a banned pattern, a naming convention), say which linter or tool rule would catch it automatically.
  - If the same issue appears several times, report it once as a pattern, with all locations.

  Never write corrected code. Under 600 words."

**Spec sub-agent** prompt should include:

- The diff command and commit list.
- The ticket's full contents, and the path of the spec file with the user story IDs the ticket covers.
- The brief:

  "The user is learning and writes all code themselves. Start with a checklist: every acceptance criterion from the ticket, marked met / partial / missing.

  Then report: (a) requirements the ticket or its user stories asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the ticket or spec line for each finding.

  For every finding, give:
  - Severity: blocker / should-fix / nit
  - Location: file:line
  - What and why: the problem, and the consequence it has in *this* code
  - Hint: point to the concept and the direction of a fix. No corrected code; at most a one-line fragment if the hint is meaningless without it.
  - Concept: one short tag (e.g. naming, error-handling, testing, modularity)

  Also:
  - For each criterion, name the test cases that would prove it (normal input, edge cases, invalid input). Describe the cases; don't write tests.
  - For scope creep, ask why it was added instead of only flagging it: sometimes it's justified.

  Never write corrected code. Under 600 words."

If no ticket was found, skip the Spec sub-agent and note this in the final report.

### 5. Aggregate

Present the two reports under `## Standards` and `## Spec` headings, verbatim or lightly cleaned. Do not merge or rerank findings, because the two axes are deliberately separate (see Why two axes).

End with a one-line summary: total findings per axis, and the worst issue within each axis (if any). Don't pick a single winner across axes: that's the reranking the separation exists to prevent.

### 6. Save the report

Write the full report to `docs/reviews/<branch>.md`. Start it with a
**Fix before merge** checklist: every blocker and should-fix finding that
belongs in this ticket, as `- [ ] <location>: <what>`. Then the Standards,
Spec and Learning sections as presented.

If a report for this branch already exists, this is a re-review: before
writing, compare with it. Mark each earlier "Fix before merge" item as fixed
or still open, and keep the still-open ones in the new checklist. Then
replace the file.

Tell the user the path, so they can tick items off as they work.

### 7. Learning

After the summary, add a `## Learning` section:

- **Main takeaway**: the single most important lesson from this review, in one sentence.
- **Questions**: 1-3 questions the user should be able to answer before fixing (e.g. "what happens on line 40 if the list is empty?").
- **Follow-up issues**: propose issues for should-fix and nit findings that don't belong in this ticket. Label them as the labels file listed in CLAUDE.md prescribes for code-review follow-ups, and mention the reviewed ticket in the body. Ask before creating any; create approved ones with `gh issue create`.

Never fix the code yourself, not even in the report.

## Why two axes

A change can pass one axis and fail the other:

- Code that follows every standard but implements the wrong thing → Standards pass, Spec fail.
- Code that does exactly what the ticket asked but breaks the conventions → Spec pass, Standards fail.

Reporting them separately stops one axis from masking the other.
