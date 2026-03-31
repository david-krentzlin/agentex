#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SSH_KEY_PATH="$HOME/.ssh/id_ed25519_agent_vm"

# shellcheck source=lib/profile.sh
source "$REPO_ROOT/lib/profile.sh"

mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

apply_profile agent-fedora "$HOME"

if [[ ! -f "$SSH_KEY_PATH" ]]; then
	ssh-keygen -t ed25519 -C "agent-vm" -f "$SSH_KEY_PATH" -N ""
	chmod 600 "$SSH_KEY_PATH"
	chmod 644 "${SSH_KEY_PATH}.pub"
fi

echo "Agent user bootstrap complete."
echo "OpenCode config installed via stow in: $HOME/.config/opencode"
echo "SSH public key: ${SSH_KEY_PATH}.pub"
