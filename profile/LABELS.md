# Labels

Use exactly these names. Don't invent new labels without asking, except
concept labels (see below).

## Status

| Label | Meaning |
|---|---|
| `needs-triage` | New, not yet reviewed by me |
| `needs-info` | Unclear; needs refinement before work can start |
| `ready` | Clear, ready to work on |

## Type

| Label | Meaning |
|---|---|
| `feature` | New behaviour, usually from a spec (created by `/to-tickets`) |
| `bug` | Something that doesn't work as specified |
| `review` | A follow-up from a code review (created by `/code-review`) |
| `decision` | A "Decide: …" ticket for an open question that blocks other work |

## Spec

`spec:<slug>`, where `<slug>` is the spec's file name in `docs/spec/` without
`.md`. Every ticket made from a spec gets it, e.g. `spec:task-tracker`.

## Concepts

What a ticket teaches or a finding is about. One or two per ticket.
Lowercase, words joined with hyphens.

Current list:

- `naming`
- `error-handling`
- `testing`
- `data-structures`
- `file-io`
- `input-validation`
- `modularity`
- `state`

A new concept label is fine when none of these fit: propose it, use the same
format, and add it to this list (I'll update this file).

## Which labels go where

| Created by | Labels |
|---|---|
| `/to-tickets` | `spec:<slug>`, `feature`, `ready`, 1-2 concepts |
| `/to-tickets` for an open question | `spec:<slug>`, `decision`, `ready` |
| `/code-review` follow-up | `review`, `needs-triage`, 1 concept |
| Bug I report myself | `bug`, `needs-triage` |
