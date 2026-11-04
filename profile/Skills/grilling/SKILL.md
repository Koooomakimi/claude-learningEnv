---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

### Scope
By default, the root of the design tree is the whole plan, decision or idea the user brought.

When another skill calls this one and defines a scope (for example "one open question" or "one change to an existing spec"), that scope is the root of the tree instead. Then:

Only explore branches that grow from that root.
Everything the calling skill marks as settled stays settled.
The session is done when the frontier within that scope is empty, not when the whole project is.
The calling skill's scope rules take precedence over anything below.

## Context: a learning setup

The user is learning to design and build projects. The point of the grilling is that **they** do the thinking. So:

- **The user answers first.** Do not give your recommended answer up front. Ask the question, then wait.
- **Then give your view.** After they answer, say whether you agree. If you'd choose differently, say what and why in one or two sentences, and let them decide. Don't push: a reasonable choice that differs from yours is fine.
- **"I don't know" is a good answer.** When the user doesn't know, don't answer for them. Lay out the realistic options and what each one trades off, then ask again. Only give your recommendation if they ask for it explicitly.
- **Explain jargon.** If a question needs a concept the user may not know, explain it in one sentence inside the question.

## Rounds

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet.

Ask at most **3 questions per round**, taking the most fundamental ones from the frontier first. Number each question. Then wait for the user's answers before the next round.

Format a round like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

---

❓ **Q2** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>
```

After the user answers, respond per question with your view (see above), then continue with the next round.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

## Facts vs decisions

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (files in the project, tools, versions), look it up yourself. For a quick lookup, do it directly; only dispatch a sub-agent with a fresh context window when the search is large. Don't block on it: only the questions downstream of a lookup wait for its result; ask the rest of the frontier now.

The _decisions_ are the user's: put each to them and wait.

## Finishing

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed.

Then give a short summary of all decisions, in the user's words, grouped by topic, and ask the user to confirm it. Do not act on it until the user confirms you have reached a shared understanding. Never write or change code as a result.

After the user confirms, offer to save the summary to docs/spec/<slug>-decisions.md
