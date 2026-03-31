# agentex

`agentex` bootstraps an isolated OpenCode development environment. 

The goal is simple: keep your host machine clean, run coding agents inside an isolated VM, and start pairing quickly with a repeatable setup.

## Quickstart

Currently only the host bootstrap is macOS-specific. The OpenCode config in `templates/dot-config/opencode/` is shared across systems. Pure Linux setup will follow with a similar architecture.

See [MACOS Instructions](/macos/opencode-lima-setup.md) for details.

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
