---
name: fix-bug
description: Fix bugs with reproduce-first workflow and deterministic regression evidence. Use when a bug is identified and needs mitigation.
---

## Workflow
1. Reproduce the issue as a failing regression test
3. Apply the minimal fix to make the test pass
4. Validate correction and regression safety.
   * Run quality gates in the project
5. Search for similar instance of the same or related bug in the code base. Bugs tend to come in clusters. Repeat fixes for those.

## Output Contract
- Regression test path is documented in task annotations.
* Report full status to user
