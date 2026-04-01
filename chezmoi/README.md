# Chezmoi Source State

This directory is the repo-managed `chezmoi` source state for the new architecture.

Current scope is intentionally minimal:

- `target=host`, `context=work`
- `target=dev`, `context=work`
- `target=agent`, `context=work`

Apply it through the repo wrapper:

```bash
./bootstrap/apply-chezmoi.sh --target host --context work
./bootstrap/apply-chezmoi.sh --target dev --context work
./bootstrap/apply-chezmoi.sh --target agent --context work
```

The wrapper renders `.chezmoi.toml.tmpl` with `chezmoi execute-template --init` so `chezmoi` itself owns the prompts for identity data.
