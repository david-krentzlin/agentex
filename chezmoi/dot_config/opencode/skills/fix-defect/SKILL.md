---
name: fix-bug
description: Fix bugs with reproduce-first workflow and deterministic regression evidence. Use when a bug is identified and needs mitigation.
---

## Workflow
1. Reproduce the issue as a failing regression test
2. Apply the minimal fix to make the test pass
3. Validate correction and regression safety
4. Search for similar instances of the same or related bug in the code base

## Output Contract
- Regression test path is documented in task annotations.
- Report full status to user.
