# Development Environment Plan

## Goal

Converge this repository into the single source of truth for three setup scopes:

- `host` for the bare macOS host setup
- `dev` for the Fedora development VM user
- `agent` for the Fedora agent user

`system-config-work` becomes a migration source and is retired once parity is reached.

## Principles

- The host is treated differently from the VM.
- The Fedora VM setup should be the same on the macOS work machine and the private machine once the VM exists.
- `dev` and `agent` are separate Linux users.
- `/workspaces` is the canonical shared workspace root inside the VM.
- A narrow writable host mount is used for easy transfer between host and VM.
- `mynvim` stays separate. This repository only owns the bridge/config glue around it.
- Prefer a system-wide `mise` install for shared toolchains. Fall back to per-user only if system-wide proves too awkward.
- `stow` manages files. Bootstrap scripts manage package installation and machine setup.

## Target Repository Layout

```text
.
├── bootstrap/
│   ├── host/
│   │   └── macos.sh
│   ├── vm/
│   │   └── macos-create-fedora.sh
│   ├── dev/
│   │   ├── fedora-system.sh
│   │   └── fedora-user.sh
│   └── agent/
│       ├── create-user.sh
│       └── fedora-user.sh
├── profiles/
│   ├── host-macos
│   ├── dev-fedora
│   └── agent-fedora
├── packages/
│   ├── common/
│   │   ├── git/
│   │   ├── zsh/
│   │   ├── starship/
│   │   └── mynvim-bridge/
│   ├── host/
│   │   ├── macos-tools/
│   │   ├── lima/
│   │   └── zsh-macos/
│   ├── dev/
│   │   ├── fedora-base/
│   │   ├── fedora-cli/
│   │   ├── mise/
│   │   ├── runtimes/
│   │   ├── lsps/
│   │   ├── tmux/
│   │   └── zsh-fedora/
│   └── agent/
│       ├── opencode/
│       ├── shell-marker/
│       └── agent-git/
└── lib/
    ├── fedora.sh
    ├── profile.sh
    └── stow.sh
```

## Package Model

### Common

- `packages/common/git`
  - Shared git config and ignores
- `packages/common/zsh`
  - Shared shell behavior used by host, dev, and agent
- `packages/common/starship`
  - Shared prompt config
- `packages/common/mynvim-bridge`
  - Environment and helper glue expected by `mynvim`
  - No actual Neovim config lives here

### Host

- `packages/host/macos-tools`
  - Minimal host-only tools
- `packages/host/lima`
  - VM lifecycle aliases and helper commands
- `packages/host/zsh-macos`
  - Homebrew and macOS-specific shell init

### Dev

- `packages/dev/fedora-base`
  - `/workspaces` setup, shared group defaults, umask glue
- `packages/dev/fedora-cli`
  - Fedora-side CLI tools and quality-of-life tools
- `packages/dev/mise`
  - Shared `mise` activation and config
- `packages/dev/runtimes`
  - Ruby, Go, Node, Java selection and install logic
- `packages/dev/lsps`
  - `ruby-lsp`, `gopls`, `metals`, `yaml-language-server`, `helm-ls`, formatters
- `packages/dev/tmux`
  - Tmux config for the dev VM
- `packages/dev/zsh-fedora`
  - Fedora-specific shell init

### Agent

- `packages/agent/opencode`
  - Current OpenCode config from `templates/dot-config/opencode`
- `packages/agent/shell-marker`
  - Agent shell marker and prompt differences
- `packages/agent/agent-git`
  - Agent-specific git identity/editor defaults if needed

## Profiles

### `profiles/host-macos`

- `common/git`
- `common/zsh`
- `common/starship`
- `common/mynvim-bridge`
- `host/zsh-macos`
- `host/macos-tools`
- `host/lima`

### `profiles/dev-fedora`

- `common/git`
- `common/zsh`
- `common/starship`
- `common/mynvim-bridge`
- `dev/fedora-base`
- `dev/fedora-cli`
- `dev/mise`
- `dev/runtimes`
- `dev/lsps`
- `dev/tmux`
- `dev/zsh-fedora`

### `profiles/agent-fedora`

- `common/git`
- `common/zsh`
- `common/starship`
- `agent/opencode`
- `agent/shell-marker`
- `agent/agent-git`

## Bootstrap Flow

### macOS Work Host

1. Clone this repository on the host.
2. Run `bootstrap/host/macos.sh`.
3. Run `bootstrap/vm/macos-create-fedora.sh`.
4. Enter the VM as the dev user.
5. Clone this repository inside the VM.
6. Run `bootstrap/dev/fedora-system.sh`.
7. Run `bootstrap/dev/fedora-user.sh`.
8. Run `bootstrap/agent/create-user.sh`.
9. Switch to `agent`, clone this repository again.
10. Run `bootstrap/agent/fedora-user.sh`.

### Private Fedora VM

1. Create the Fedora VM using the private-machine-specific method.
2. Clone this repository inside the VM.
3. Run `bootstrap/dev/fedora-system.sh`.
4. Run `bootstrap/dev/fedora-user.sh`.
5. Run `bootstrap/agent/create-user.sh`.
6. Run `bootstrap/agent/fedora-user.sh`.

## Script Responsibilities

### `bootstrap/host/macos.sh`

- Install or verify host prerequisites
- Apply `host-macos` profile
- Set up host shell aliases for VM lifecycle
- Create a default transfer directory on the host, for example `~/VMTransfer`

### `bootstrap/vm/macos-create-fedora.sh`

- Create the Lima Fedora VM
- Keep project work inside the VM by default
- Mount a narrow writable transfer directory only
- Recommended mount:
  - Host: `~/VMTransfer`
  - Guest: `/transfer`
- Support broader mounts only as an explicit opt-in later

### `bootstrap/dev/fedora-system.sh`

- Run as root
- Install Fedora packages with `dnf`
- Create a shared group, for example `devvm`
- Create `/workspaces`
- Set group ownership and setgid on `/workspaces`
- Install `mise` system-wide if feasible
- Install shared runtimes and tools for both users
- Add global shell activation if needed

### `bootstrap/dev/fedora-user.sh`

- Run as the dev user
- Apply the `dev-fedora` profile via `stow`
- Set user defaults
- Verify `mynvim` bridge env is in place

### `bootstrap/agent/create-user.sh`

- Create the `agent` user
- Add `agent` to the shared `devvm` group
- Do not grant sudo by default
- Set the default shell
- Create the agent SSH directory

### `bootstrap/agent/fedora-user.sh`

- Run as `agent`
- Apply the `agent-fedora` profile
- Install OpenCode config
- Generate an agent SSH key
- Configure the agent-only shell marker

## Workspace Model

- `/workspaces` is the canonical VM workspace root
- `dev` and `agent` are in the same Unix group
- Both users should use `umask 0002`
- Directories under `/workspaces` should use setgid so new files preserve group ownership
- `/transfer` is only for easy file transfer between host and VM
- `/transfer` is not the primary development workspace

## Tooling Strategy

### Fedora packages via `dnf`

- `git`
- `stow`
- `zsh`
- `tmux`
- `neovim`
- `ripgrep`
- `fd-find`
- `jq`
- `curl`
- `gcc`
- `gcc-c++`
- `make`
- `openssh-clients`
- `tar`
- `unzip`

### Shared runtimes via `mise`

- `ruby`
- `go`
- `node`
- `java`

### Editor support tools

- `ruby-lsp`
- `gopls`
- `metals`
- `yaml-language-server`
- `helm-ls`
- `shfmt`
- `stylua`
- `yq`

Neovim should consume tools already on `PATH`. Do not depend on Mason for baseline installation.

## System-wide `mise` Plan

Target:

- One shared `mise` installation
- One shared runtime/tool store for both users
- Global shell activation where appropriate

Early spike:

- Validate a system-wide `mise` binary and shared data dir
- Verify both `dev` and `agent` can resolve the same shims and runtimes cleanly
- Verify installs do not become permission-fragile

Fallback:

- Keep the same package and profile layout
- Switch only the `mise` install mode to per-user if system-wide proves too awkward

## Migration Map

### From `system-config-work`

- `packages/git` -> `packages/common/git`
- `packages/zsh` -> split into:
  - `packages/common/zsh`
  - `packages/host/zsh-macos`
  - `packages/dev/zsh-fedora`
- `packages/starship` -> `packages/common/starship`
- `packages/tmux` -> `packages/dev/tmux`
- `packages/tools` -> split into host and Fedora CLI packages
- `packages/mise` -> `packages/dev/mise`
- `packages/helix` install logic -> seed for `packages/dev/lsps`
- `packages/opencode` env snippet -> merge into `packages/agent/opencode` or `packages/agent/shell-marker`

### From current `agentex`

- `macos/bootstrap-host.sh` -> split into:
  - `bootstrap/host/macos.sh`
  - `bootstrap/vm/macos-create-fedora.sh`
- `macos/bootstrap-vm.sh` -> split into:
  - `bootstrap/dev/fedora-system.sh`
  - `bootstrap/dev/fedora-user.sh`
  - `bootstrap/agent/create-user.sh`
  - `bootstrap/agent/fedora-user.sh`
- `templates/dot-config/opencode/*` -> `packages/agent/opencode/*`

### From `mynvim`

- Do not migrate the Neovim config into this repository
- Add a bridge package only for env and compatibility hooks

## Execution Order

1. Introduce the new repository layout.
2. Add profile files and the common profile runner.
3. Split the current host bootstrap into host and VM-create scripts.
4. Port OpenCode templates into `packages/agent/opencode`.
5. Port shared git, zsh, and starship config.
6. Split zsh into common, macOS, and Fedora overlays.
7. Add the Fedora system bootstrap with `/workspaces` and the shared group.
8. Run the system-wide `mise` spike.
9. Add runtimes and LSP install scripts.
10. Port tmux.
11. Add agent user creation and agent profile bootstrap.
12. Validate the full flow on a clean Lima VM.
13. Retire `system-config-work` once parity is reached.

## Validation Checklist

- A fresh macOS host can bootstrap itself with the `host-macos` profile
- The Lima VM is created with only `/transfer` mounted by default
- `/workspaces` exists and is group-shared between `dev` and `agent`
- The `dev` user gets Ruby, Go, Scala, Helm, tmux, shell config, and the `mynvim` bridge
- The `agent` user gets OpenCode config and no sudo
- Both users can execute the shared toolchain from `mise`
- `mynvim` can attach to PATH-installed LSPs without Mason being required
- Ruby, Go, Scala, YAML, and Helm templates all have working editor support
- No host kube config, cloud creds, or admin tooling is leaked into the VM

## Recommended Implementation Sequence

1. Repository layout plus profile runner
2. macOS host bootstrap and Lima creation with `/transfer`
3. Fedora system bootstrap with `/workspaces`
4. System-wide `mise` spike
5. Dev profile
6. Agent profile
