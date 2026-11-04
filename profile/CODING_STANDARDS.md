# Coding standards

My personal standards, used during code review. A project's own
`docs/CODING_STANDARDS.md` overrides these where they conflict.

Only judgement calls belong here. Anything a formatter or linter can check
(formatting, import order, line length) is left to those tools.

## Naming

- Names say what something is or does, without needing a comment.
- Use the project glossary's terms; never its `_Avoid_` words.
- Functions are verbs (`load_tasks`), values are nouns (`task_count`).
- No abbreviations unless they're more common than the full word (`id`, `url`).

## Functions

- A function does one thing. If its name needs "and", split it.
- Prefer returning values over changing things passed in.
- More than three or four parameters is a sign that some of them belong together.

## Errors

- Never silently ignore an error. Handle it, or let it reach a place that can.
- Error messages say what went wrong and, where possible, what to do about it.
- Validate input where it enters the program, not deep inside.

## Structure

- Code that changes together lives together.
- No code for needs the spec doesn't have yet.
- No copy-pasted logic: when the same thing appears a third time, extract it.

## Comments

- Comments explain *why*, not *what*. If the *what* needs a comment, improve the code.
- No commented-out code; git remembers it.

## Tests

- Tests check behaviour from the outside, not internal details.
- Every acceptance criterion has at least one test.
- Edge cases and invalid input get tests too, not just the happy path.

## Growing this file

When a review teaches me something I want to keep doing, I add a rule here, in
my own words. When a rule can be checked by a tool, I move it to that tool.
