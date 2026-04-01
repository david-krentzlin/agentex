# Host Agent Handoff

Use this document to continue the current architecture pivot from the macOS host side.

## Repository State

- Repository: `agentex`
- Active branch: `restructure-dev-env-layout`
- Main plan: `DEV_ENV_PLAN.md`
- Current setup guide: `README.md`

## Goal

The repository is no longer converging on the custom `stow` and split bootstrap flow as the target architecture.

The new target architecture is:

- Lima for the Fedora VM lifecycle on macOS
- `cloud-init` for first-boot VM provisioning
- `chezmoi` for target-aware and context-aware configuration
- `mise` for runtimes and tools

Configuration selectors:

- `target`: `host`, `dev`, `agent`
- `context`: `work`, `private`

Only `context=work` is being built right now.

## Current Mission

Build and validate the minimal first slice:

1. `target=host`, `context=work`
2. `target=dev`, `context=work`
3. `target=agent`, `context=work`

Primary outcomes:

- macOS host can install or verify Lima and `chezmoi`
- Lima can create a Fedora VM from the repo-managed template
- cloud-init-backed provisioning creates:
  - `dev`
  - `agent`
  - shared `/workspaces`
  - minimal packages
  - `chezmoi`
  - `mise`
- repo-managed `chezmoi` can apply minimal config for each target
- host gets `,dev` and `,agent` entry commands

## Current Deliverables In Tree

- `bootstrap/host/macos.sh`
- `bootstrap/vm/macos-create-fedora.sh`
- `bootstrap/apply-chezmoi.sh`
- `lima/`
- `cloud-init/`
- `chezmoi/`
- `mise/`

## What Is Explicitly Legacy

These remain as reference material only and should not be expanded further:

- `packages/`
- `profiles/`
- `lib/stow.sh`
- the old split `bootstrap/dev/*` and `bootstrap/agent/*` path
- `macos/bootstrap-vm.sh`

## Rules For The Host Agent

- Prefer the new Lima + cloud-init + `chezmoi` + `mise` path.
- Keep changes small and additive.
- Do not delete the legacy path yet.
- Do not reintroduce homegrown config orchestration if `chezmoi` can do the job.
- Keep `mynvim` external.
- Do not hardcode private identity data in the repo.

## Good Next Deliverables

1. First successful host bootstrap using `chezmoi`
2. First successful Fedora VM create from the repo-managed Lima template
3. First successful minimal `chezmoi` apply for `dev` and `agent`
4. Incremental package rollout after that baseline is proven
