---
name: domain-modeling
description: Build and sharpen a project's domain model. Use when discussing codebase terminology, writing or editing docs/GLOSSARY.md, or recording or editing an ADR in docs/adr/.
---

# Domain Modeling

Actively build and sharpen the project's domain model as you design. This is the *active* discipline: challenging terms, inventing edge-case scenarios, and writing the glossary and decisions down the moment they crystallise. (Merely *reading* `docs/GLOSSARY.md` for vocabulary is not this skill: that's a one-line habit any skill can do. This skill is for when you're changing the model, not just consuming it.)

## Context: a learning setup

The user is learning to build projects and writes all code themselves. The project is read-only for you, except the `docs/` folder. So:

- **Only ever write inside `docs/`.** The glossary, glossary map and ADRs all live there. Never try to create files elsewhere.
- **You can't commit.** The user reviews and commits everything you write in `docs/`. After writing or changing a file, say in one line which file changed and what.
- **The thinking belongs to the user.** Ask the user to put things in their own words first, then sharpen. Never invent reasons or decisions they didn't state.
- **Teach while you do it.** The first time you propose a glossary entry or an ADR in a project, explain in one or two sentences what it is and why it helps.

## File structure

Most projects have a single context:

```
/
├── docs/
│   ├── GLOSSARY.md
│   ├── spec/
│   └── adr/
│       ├── 0001-sqlite-for-storage.md
│       └── 0002-cli-before-gui.md
└── src/
```

If `docs/GLOSSARY-MAP.md` exists, the project has multiple contexts. The map points to where each one lives:

```
/
├── docs/
│   ├── GLOSSARY-MAP.md
│   ├── glossary/
│   │   ├── ordering.md
│   │   └── billing.md
│   ├── spec/
│   └── adr/
│       ├── 0001-...md              ← system-wide decisions
│       ├── ordering/               ← context-specific decisions
│       └── billing/
└── src/
```

Create files lazily: only when you have something to write. If no `docs/GLOSSARY.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in the glossary, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y. Which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, first ask what they mean by it. Then propose a precise canonical term, and say why it's more precise. "You're saying 'account': do you mean the person using the app, or the person paying? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts. Let the user answer before you offer your own view.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it as a question, not a fix: "Your code cancels entire Orders, but you just said partial cancellation is possible. Which is right?"

### Update the glossary inline

When a term is resolved, update `docs/GLOSSARY.md` right there. Don't batch these up: capture them as they happen. Base the definition on how the user described it, tightened up. Use the format in [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md).

The glossary should be totally devoid of implementation details. Do not treat it as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and nothing else. Specs live in `docs/spec/`.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse**: the cost of changing your mind later is meaningful
2. **Surprising without context**: a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off**: there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR.

When one qualifies, ask the user to state the decision and their reasons in their own words, then write the ADR from that. If their reasoning has a gap (an alternative they didn't consider, a consequence they missed), ask about it before writing. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).
