# home-sweet-home

Private bootstrap repo for your macOS host and your Fedora Lima dev VM.

## What To Use

Use these scripts only:

- `bootstrap/host/macos.sh`
- `bootstrap/vm/macos-create-fedora.sh`
- `bootstrap/apply-chezmoi.sh`

Do not use the older `bootstrap/dev/*` or `bootstrap/agent/*` scripts. They are legacy and are not the current path.

## Requirements

- macOS
- Homebrew already installed
- Git
- Your git identity details
- Your GitHub username
- Your work username for `--context work`

## First-Time Setup

1. Clone this repo on your Mac.
2. Run the host bootstrap.

```bash
./bootstrap/host/macos.sh --context work
```

3. Create the Fedora VM.

```bash
./bootstrap/vm/macos-create-fedora.sh --context work
```

4. Open the VM as the `dev` user.

```bash
,dev
```

5. Inside the VM, clone this repo into `/workspaces`.

```bash
git clone <private-repo-url> /workspaces/home-sweet-home
cd /workspaces/home-sweet-home
```

6. Apply the `dev` user config inside the VM.

```bash
./bootstrap/apply-chezmoi.sh --target dev --context work
```

7. Open the VM as the `agent` user.

```bash
,agent
```

8. Apply the `agent` user config from the same repo checkout.

```bash
cd /workspaces/home-sweet-home
./bootstrap/apply-chezmoi.sh --target agent --context work
```

## What You Get

- macOS host tools installed with Homebrew
- a Fedora Lima VM named `dev`
- host entry commands: `,dev` and `,agent`
- `chezmoi`-managed config for `host`, `dev`, and `agent`
- `mise` config applied when available

## Daily Use

- Open the dev shell with `,dev`
- Open the agent shell with `,agent`
- Pull repo changes and re-run `bootstrap/apply-chezmoi.sh` for the target you changed

## Re-Apply Config

On macOS host:

```bash
./bootstrap/apply-chezmoi.sh --target host --context work
```

Inside the VM as `dev`:

```bash
./bootstrap/apply-chezmoi.sh --target dev --context work
```

Inside the VM as `agent`:

```bash
./bootstrap/apply-chezmoi.sh --target agent --context work
```

## Prompted Values

The `chezmoi` apply script will prompt for:

- git author name
- git author email
- GitHub username
- work username when `--context work` is used

## Current Limits

- VM setup currently supports only `--context work`
- `--context private` is only for the macOS host flow right now
- The repo is not mounted automatically into the VM, so keep a clone in `/workspaces/home-sweet-home`
