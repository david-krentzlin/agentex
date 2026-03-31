# Host Agent Handoff

Use this document to start a new agent on the macOS host so it can continue the work from the host side.

## Repository State

- Repository: `agentex`
- Active branch: `restructure-dev-env-layout`
- Main plan: `DEV_ENV_PLAN.md`
- New preferred setup guide: `macos/opencode-lima-setup.md`

## Goal

Continue the migration of this repository into the single source of truth for:

- `host` for the macOS host setup
- `dev` for the Fedora development VM user
- `agent` for the Fedora agent user

The host should stay separate from the dev VM. The VM should be the main development environment. The agent should run as a separate Linux user inside the VM.

## What Is Already Implemented

### New structure

- `bootstrap/host/macos.sh`
- `bootstrap/vm/macos-create-fedora.sh`
- `bootstrap/dev/fedora-system.sh`
- `bootstrap/dev/fedora-user.sh`
- `bootstrap/agent/create-user.sh`
- `bootstrap/agent/fedora-user.sh`
- `lib/`
- `profiles/`
- `packages/`

### New profiles

- `profiles/host-macos`
- `profiles/dev-fedora`
- `profiles/agent-fedora`

### Current package direction

- shared shell/git/starship setup under `packages/common/`
- host-specific setup under `packages/host/`
- Fedora dev setup under `packages/dev/`
- OpenCode agent setup under `packages/agent/`

### Toolchain direction

- Fedora system bootstrap now installs a shared `mise` store
- repo-managed manifests exist for runtime and LSP setup:
  - `packages/dev/mise/dot-config/mise/config.toml`
  - `packages/dev/lsps/node-packages.txt`
  - `packages/dev/lsps/ruby-gems.txt`
  - `packages/dev/lsps/go-tools.txt`
  - `packages/dev/lsps/coursier-apps.txt`

### Legacy flow status

- `macos/bootstrap-host.sh` now delegates to `bootstrap/host/macos.sh` by default
- `macos/bootstrap-vm.sh` is now explicitly legacy single-user bootstrap
- legacy VM bootstrap now reads OpenCode config from `packages/agent/opencode/dot-config/opencode`

## What Has Not Been Proven Yet

These parts were implemented and syntax-checked, but not fully validated from a real macOS host:

- `bootstrap/host/macos.sh`
- `bootstrap/vm/macos-create-fedora.sh`
- Lima creation and transfer mount behavior
- full end-to-end Fedora bootstrap from a fresh VM
- system-wide `mise` behavior under real execution
- `stow` application against a real user home on target machines

## Host Agent Mission

The host-side agent should take over and do the first real validation pass.

Primary goals:

1. Validate the new host bootstrap on macOS.
2. Validate Fedora VM creation through Lima.
3. Validate the new split dev/agent bootstrap flow inside the VM.
4. Fix any issues discovered during real execution.
5. Keep changes on `restructure-dev-env-layout`.

## Suggested Starting Prompt For The Host Agent

```text
Continue work on branch `restructure-dev-env-layout`.

Read these files first:
- HOST_AGENT_HANDOFF.md
- DEV_ENV_PLAN.md
- README.md
- macos/opencode-lima-setup.md

Then validate the new preferred setup flow end-to-end from the macOS host:
- ./bootstrap/host/macos.sh
- ./bootstrap/vm/macos-create-fedora.sh
- enter the Fedora VM
- sudo ./bootstrap/dev/fedora-system.sh
- ./bootstrap/dev/fedora-user.sh
- sudo ./bootstrap/agent/create-user.sh
- as agent: ./bootstrap/agent/fedora-user.sh

Fix issues you encounter. Prefer minimal changes. Do not revert unrelated work.
```

## Recommended Validation Sequence

### On macOS host

1. Confirm the repo is on `restructure-dev-env-layout`.
2. Run:

```bash
./bootstrap/host/macos.sh
```

3. Check:
   - `stow` installed or installed by script
   - `lima` installed or installed by script
   - `~/VMTransfer` created
   - host profile files applied as expected

4. Run:

```bash
./bootstrap/vm/macos-create-fedora.sh
```

5. Check:
   - Lima instance created successfully
   - writable transfer mount exists
   - guest mount is `/transfer`

### Inside Fedora VM as dev user

1. Clone the repo.
2. Run:

```bash
sudo ./bootstrap/dev/fedora-system.sh
./bootstrap/dev/fedora-user.sh
```

3. Check:
   - `/workspaces` exists
   - group ownership and setgid are correct
   - shared `mise` install is usable
   - Ruby, Go, Node, Java toolchain access works
   - `helm-ls`, `yaml-language-server`, `gopls`, `ruby-lsp`, `metals`, `shfmt`, `stylua`, `yq` resolve on `PATH`
   - profile application via `stow` works

### Inside Fedora VM for agent user

1. Run:

```bash
sudo ./bootstrap/agent/create-user.sh
```

2. Switch to `agent`, clone the repo again, then run:

```bash
./bootstrap/agent/fedora-user.sh
```

3. Check:
   - agent user has no sudo by default
   - agent user is in shared group
   - OpenCode config lands in `~/.config/opencode`
   - agent SSH key is created
   - shell marker setup works
   - agent can work in `/workspaces`

## Known Risk Areas

- `mise` system-wide installation behavior on Fedora
- `mise exec` and `reshim` behavior under the shared store
- availability of optional Fedora packages used by shell aliases
- coursier-based Metals installation path and permissions
- Lima `--plain` plus mount behavior on macOS
- host profile application via `stow` against an existing host config

## Rules For The Host Agent

- Prefer the new `bootstrap/` flow over the legacy `macos/` flow.
- Keep the legacy scripts only as compatibility wrappers unless there is a concrete reason to change more.
- Prefer small fixes over architectural rewrites.
- Do not reintroduce broad host workspace mounts as the default.
- Keep `mynvim` external. This repo only owns the bridge around it.
- Do not remove unrelated work in the tree.

## Good Next Deliverables

1. A clean end-to-end host + VM bootstrap that works on macOS.
2. A cleaned-up `README.md` repository layout section that reflects the new structure.
3. Removal or deactivation of stale duplication once the new flow is proven.
