#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "Error: bootstrap/host/macos.sh must be run on macOS." >&2
	exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
	echo "Error: Homebrew is required on the macOS host." >&2
	exit 1
fi

if ! command -v stow >/dev/null 2>&1; then
	brew install stow
fi

if ! command -v limactl >/dev/null 2>&1; then
	brew install lima
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TRANSFER_DIR="${HOME}/VMTransfer"

# shellcheck source=lib/profile.sh
source "$REPO_ROOT/lib/profile.sh"

mkdir -p "$TRANSFER_DIR"
apply_profile host-macos "$HOME"

echo "Host bootstrap complete."
echo "Transfer directory: $TRANSFER_DIR"
echo "Next: run bootstrap/vm/macos-create-fedora.sh"
