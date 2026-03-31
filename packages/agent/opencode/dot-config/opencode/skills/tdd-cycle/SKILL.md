---
name: software-design
description: General software design - simplicity, coupling, cohesion, boundaries, error handling, naming, API design. Use when discussing design options, during pair programming sessions, when features are changed or added.
---

## Principles (in priority order)

1. **Simplicity**: Simplest design that satisfies known requirements. No speculative generalization.
2. **Naming**: If a name needs a comment, the name is wrong. Names are documentation.
3. **Single responsibility**: One reason to change per module, function, or type.
4. **Coupling and cohesion**: Things that change together live together. Things that change independently stay apart.
5. **Composition over inheritance**: Combine small parts. Prefer interfaces over class hierarchies.
6. **Explicit dependencies**: Declare what you need. No hidden globals.
7. **Error handling**: Pick a strategy per boundary. Be consistent within it.
8. **API design**: Public interfaces are contracts. Small surface. Easy to use correctly.

## When These Aren't Enough

When the domain has distinct subdomains with different rules, complex entity lifecycles, or code and team language mismatch -> load the `ddd` skill.

## In Review

1. Name the principle that's violated or could be improved.
2. State the tradeoff: what improves, what it costs, when it matters.
3. Suggest the smallest change that addresses it.
4. Justify any pattern with the specific problem it solves here.
