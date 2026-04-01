---
name: implement-feature
description: Implement approved features incrementally with deterministic pre-review checks. Use when user asks to implement or change a feature.
---

## Workflow
1. Create a feature branch to isolate
2. Clarify acceptance criteria are complete and clear. If user did not provide them, ask the user.
3. Apply TDD to drive the feature
   * Add UATs
   - Follow the `tdd-cycle` skill: write a failing test, make it pass, then refactor before moving on.

## Output Contract
- No transition to review without a passing quality gate.
* evidence paths are workspace-local

## Rules
* Simplest working solution. No over-engineering.
* No abstractions for single-use operations.
* No speculative features or "you might also want..."
* Read the file before modifying it. Never edit blind.
* No docstrings or type annotations on code not being changed.
* No error handling for scenarios that cannot happen.
* Three similar lines is better than a premature abstraction.
