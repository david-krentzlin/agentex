# Development Environment Plan

## Goal

Make this repository the single source of truth for a development environment with two explicit selectors:

- `target`: `host`, `dev`, `agent`
- `context`: `work`, `private`

Where:

- `host` means the macOS host machine
- `dev` means the Fedora VM development user
- `agent` means the Fedora VM agent user

Initial scope is `context=work`. `context=private` is designed in from the start but not implemented yet.

## Architecture

The environment will be built from proven tools with clear responsibilities:

- Lima manages the Fedora VM lifecycle on macOS.
- `cloud-init` provisions the VM on first boot.
- `chezmoi` manages target-aware and context-aware configuration.
- `mise` manages runtimes and developer tools.

The existing custom `stow` and bootstrap flow is no longer the target architecture. It remains reference material until the new path is proven.

## Selectors

The configuration model is intentionally simple.

### `target`

- `host`
- `dev`
- `agent`

Derived meaning:

- `host` implies macOS if context == work and fedora if context == private
- `dev` and `agent` imply Fedora inside the Lima VM
- `dev` and `agent` are separate Linux users

### `context`

- `work`
- `private`

Derived meaning:

- `work` may include work-only configuration and tooling
- `private` will later include private-machine-specific configuration

## Principles

- Prefer standard tools over custom orchestration.
- Keep the host separate from the VM.
- Keep `dev` and `agent` as separate Linux users inside the VM.
- Use `/workspaces` as the canonical shared workspace root inside the VM.
- Use `chezmoi` for config convergence, not ad hoc symlink logic.
- Use `mise` for runtimes and developer tools as much as possible.
- Prompt for private identity data like name and email instead of committing it.
- Start minimal and add configuration packages one by one.
- Keep `mynvim` external. This repo only owns the bridge around it.

## Tool Responsibilities

### Lima

- Create and run the Fedora VM on macOS.
- Pass first-boot configuration via `cloud-init`.
- Remain the only host-side VM management layer.

### cloud-init

- Perform first-boot VM provisioning.
- Create the `dev` and `agent` users.
- Create the shared group and `/workspaces`.
- Install the minimum packages needed to make the VM usable.
- Install or enable `chezmoi` and `mise` if needed.

`cloud-init` should stay focused on first-boot system concerns. It should not become the long-term home for user configuration logic.

### chezmoi

- Manage user-facing configuration for all targets.
- Apply target-aware and context-aware config.
- Prompt for user-specific data like git name and email.
- Use `.chezmoiignore.tmpl` to ignore whole config areas that do not apply.
- Manage host aliases such as `,dev` and `,agent`.
- Manage agent-only OpenCode configuration.

### mise

- Manage shared or target-specific runtimes.
- Manage developer tools and language servers where feasible.
- Keep manifests in the repo.

Current preference is to keep `mise` shared/system-wide inside the VM unless that proves too fragile.

## Repository Shape

The exact file layout can evolve, but the intended structure is:

```text
.
├── bootstrap/
│   ├── host/
│   │   └── macos.sh
│   └── vm/
│       └── macos-create-fedora.sh
├── lima/
│   └── dev-fedora.yaml.tmpl
├── cloud-init/
│   └── dev-fedora-user-data.yaml.tmpl
├── chezmoi/
│   ├── .chezmoiignore.tmpl
│   ├── common/
│   ├── host/
│   ├── vm/
│   ├── dev/
│   ├── agent/
│   ├── work/
│   └── private/
└── mise/
    ├── config.toml
    └── manifests/
```

Notes:

- `chezmoi/` is the source state owned by this repo.
- The directories under `chezmoi/` are organizational. `chezmoi` templates and ignore rules decide what applies for a given `target` and `context`.
- The current custom `packages/`, `profiles/`, and `lib/stow.sh` direction is legacy and should not be expanded further.

## Minimal First Slice

The first milestone should prove the architecture, not full parity.

### Host work target

- Ensure the macOS host can install or verify the minimum dependencies.
- Apply `chezmoi` for `target=host` and `context=work`.
- Install host aliases:
  - `,dev` to enter the VM as the dev user
  - `,agent` to enter the VM as the agent user

### VM work targets

- Lima creates a Fedora VM using `cloud-init`.
- `cloud-init` creates:
  - `dev`
  - `agent`
  - shared group
  - `/workspaces`
- `chezmoi` applies a minimal `target=dev` and `target=agent` configuration.
- `agent` receives the OpenCode config.
- `mise` installs only a small initial toolset.

### Not in the first slice

Do not start with full parity. Add these later, one by one:

- `zsh`
- `starship`
- `tmux`
- `neovim` integration
- extra CLI utilities
- LSP stacks
- private context support

## Configuration Strategy

### chezmoi data

The `chezmoi` templates should receive explicit values for:

- `target`
- `context`
- `user.name`
- `user.email`

Optional later data may include:

- GitHub username
- machine labels
- work-specific defaults

Private identity data must never be hardcoded in the repository.

### .chezmoiignore.tmpl

Use `.chezmoiignore.tmpl` to exclude whole configuration areas that do not apply to the current target and context.

Examples:

- ignore `host/` for VM targets
- ignore `agent/` for `dev`
- ignore `work/` for `private`
- ignore `private/` for `work`

This should be the primary bulk-selection mechanism rather than scattering conditionals across every file.

## VM Model

- The Fedora VM is the main development environment.
- `/workspaces` is the canonical shared workspace root.
- `dev` and `agent` share access through a common Unix group.
- `agent` should not have sudo by default.
- The host should not become the primary development workspace.

## Tooling Model

`mise` stays the main tool manager.

The initial manifest should be intentionally small. Expand only after the minimal flow is proven.

Good early candidates:

- `opencode`
- one or two core runtimes if truly required

Everything else should be added incrementally and validated in isolation.

## Incremental Package Rollout

After the minimal architecture is proven, add configuration and tooling in small steps.

Suggested order:

1. git identity and shared git config
2. minimal shell config
3. host aliases for VM entry
4. agent OpenCode config
5. `zsh`
6. `starship`
7. `tmux`
8. `mynvim` bridge
9. runtimes via `mise`
10. editor tooling and LSPs

Each addition should be target-aware, context-aware, and validated before the next one is added.

## Migration Stance

- Do not keep extending the custom `stow`/profile architecture.
- Do not delete the current branch work yet.
- Use the current branch contents as migration reference material.
- Replace the old path only after the new one is proven end-to-end.

This is a design reset, not a history reset.

## Validation Checklist

### Minimal work scope

- A fresh macOS host can bootstrap with `target=host` and `context=work`.
- The host gets working `,dev` and `,agent` aliases.
- Lima creates the Fedora VM with `cloud-init`.
- The VM boots with `dev` and `agent` present.
- `/workspaces` exists with shared-group access.
- `agent` has no sudo by default.
- `chezmoi` can apply successfully for:
  - `target=host`, `context=work`
  - `target=dev`, `context=work`
  - `target=agent`, `context=work`
- `chezmoi` prompts for name and email instead of reading them from the repo.
- The agent gets OpenCode config in the expected location.
- The initial `mise` manifest resolves successfully.

### Later scope

- Additional config packages can be added one by one without breaking existing targets.
- `context=private` can be introduced without changing the target model.

## Execution Order

1. Replace the plan with the new architecture and stop growing the legacy path.
2. Add a minimal host bootstrap that installs or verifies Lima and `chezmoi`.
3. Add the Lima template and `cloud-init` VM bootstrap.
4. Add a minimal `chezmoi` source state with `target` and `context` selectors.
5. Prove `target=host`, `target=dev`, and `target=agent` for `context=work`.
6. Add the first config package after the minimal flow is proven.
7. Continue package-by-package until the work setup reaches parity.
8. Add `context=private` later on the same architecture.
