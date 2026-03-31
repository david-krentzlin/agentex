#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# shellcheck source=lib/profile.sh
source "$REPO_ROOT/lib/profile.sh"

mkdir -p "$HOME/.config" "$HOME/.local/bin"
apply_profile dev-fedora "$HOME"

echo "Dev user bootstrap complete."
echo "Clone or link mynvim separately if needed."
echo "Next: run bootstrap/agent/create-user.sh"
