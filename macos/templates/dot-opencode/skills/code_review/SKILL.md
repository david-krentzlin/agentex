---
name: code-review
description: Review changes for intent fit, size, and guardrail alignment. Use when you need to review code, pull requests, or before commits.
---

## Rules

State the bug. Show the fix. Stop.
No suggestions beyond the scope of the review.
No compliments on the code before or after the review.

## Workflow
1. **Gather intent**
   - Read the task, issue summary, or commit message to understand the intended change.
2. **Inspect the diff**
   - Note the total additions/deletions and number of files to judge change size. Flag unusually large diffs or sprawling file counts.
3. **Check consistency with existing patterns**
   - Compare new code to nearby code for naming, structure, error handling, logging, and dependency usage.
4. **Consult ADRs**
   - Search for architecture decision records under `docs/adr*/`, `doc/adr/`, or similar directories using `rg`.
   - Read any ADRs that cover the modified area or feature. Confirm the changes follow the recorded decisions; call out mismatches or outdated ADRs.
5. **Validate scope vs. intent**
   - Confirm each change maps back to the stated intent; highlight stray edits or missing pieces.
   - Ensure the change size matches the scope (e.g., refactors belong in separate commits, formatting-only files should be isolated).
6. **Assess testing and evidence**
   - Look for new/updated tests, QA artifacts, or doc updates that prove the change works.
   - If evidence is missing, request it explicitly.

## Output
- Provide clear verdicts (`Approve`, `Needs changes`, or `Blocker`) with actionable feedback and rerunnable commands if applicable.
