# Glossary Format

# Locations: 
every file and folder this skill reads or writes (the spec folder, glossary, ADR folder, architecture doc, standards, labels file) is listed under "Where things are" in CLAUDE.md. Look them up there; don't assume paths.

## Structure

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others under `_Avoid_`.
- **Keep definitions tight.** One or two sentences max. Define what it IS, not what it does.
- **Only include terms specific to this project's context.** General programming concepts (timeouts, error types, utility patterns) don't belong even if the project uses them extensively. Before adding a term, ask: is this a concept unique to this context, or a general programming concept? Only the former belongs.
- **Group terms under subheadings** when natural clusters emerge. If all terms belong to a single cohesive area, a flat list is fine.

## Single vs multi-context projects

All glossary files live in `docs/`, because that is the only writable folder.

**Single context (most projects):** One glossary.

**Multiple contexts:** A `docs/GLOSSARY-MAP.md` lists the contexts, where their glossaries live, and how they relate to each other. Each context's glossary lives in `docs/glossary/<context>.md`:

```md
# Glossary Map

## Contexts

- [Ordering](./glossary/ordering.md): receives and tracks customer orders
- [Billing](./glossary/billing.md): generates invoices and processes payments
- [Fulfillment](./glossary/fulfillment.md): manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`
```

The skill infers which structure applies:

- If `docs/GLOSSARY-MAP.md` exists, read it to find contexts
- If only glossary exists, single context
- If neither exists, create glossary lazily when the first term is resolved

When multiple contexts exist, infer which one the current topic relates to. If unclear, ask.

Most learning projects need a single context. Only suggest splitting into contexts when the user's project clearly has separate areas with their own vocabulary, and explain why.
