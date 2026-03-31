# agentex

`agentex` bootstraps an isolated OpenCode development environment. 

The goal is simple: keep your host machine clean, run coding agents inside an isolated VM, and start pairing quickly with a repeatable setup.

The repository is being restructured into three setup scopes:

- `host` for the bare macOS host setup
- `dev` for the Fedora development VM user
- `agent` for the Fedora agent user

The migration plan lives in `DEV_ENV_PLAN.md`.

For handing work to an agent running on the macOS host, use `HOST_AGENT_HANDOFF.md`.

## Quickstart

Currently only the host bootstrap is macOS-specific. The OpenCode config in `templates/dot-config/opencode/` is shared across systems. Pure Linux setup will follow with a similar architecture.

See [MACOS Instructions](/macos/opencode-lima-setup.md) for details.

New bootstrap entrypoints are being introduced under `bootstrap/` for the long-term layout:

- `bootstrap/host/macos.sh`
- `bootstrap/vm/macos-create-fedora.sh`
- `bootstrap/dev/fedora-system.sh`
- `bootstrap/dev/fedora-user.sh`
- `bootstrap/agent/create-user.sh`
- `bootstrap/agent/fedora-user.sh`

The Fedora system bootstrap now installs a shared `mise` toolchain store and uses these repo-managed manifests:

- `packages/dev/mise/dot-config/mise/config.toml`
- `packages/dev/lsps/node-packages.txt`
- `packages/dev/lsps/ruby-gems.txt`
- `packages/dev/lsps/go-tools.txt`
- `packages/dev/lsps/coursier-apps.txt`

Host sharing is off by default. If you want to edit a project on the host while the agent works on it inside the VM, run `macos/bootstrap-host.sh --shared-dir /absolute/host/path` to mount that directory inside the guest at `~/Code`.

## Repository layout

```text
.
├── README.md
├── templates
│   └── dot-config
│       └── opencode
│           ├── AGENTS.md
│           ├── commands
│           ├── opencode.json
│           └── skills
└── macos
    ├── bootstrap-host.sh
    ├── bootstrap-vm.sh
    └── opencode-lima-setup.md
```
