# agentex

`agentex` bootstraps an isolated OpenCode development environment. 

The goal is simple: keep your host machine clean, run coding agents inside an isolated VM, and start pairing quickly with a repeatable setup.

## Quickstart

Currently only MacOS is supported. Pure linux setup will follow with a similar architecture.

See [MACOS Instructions](/macos/opencode-lima-setup.md) for details

## Repository layout

```text
.
├── README.md
└── macos
    ├── bootstrap-host.sh
    ├── bootstrap-vm.sh
    ├── opencode-lima-setup.md
    └── templates
        ├── AGENTS.md
        ├── opencode.json
        └── dot-opencode
            ├── commands
            └── skills
```

