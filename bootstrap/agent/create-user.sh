#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
AGENT_USER="agent"
DEV_GROUP="devvm"

# shellcheck source=lib/fedora.sh
source "$REPO_ROOT/lib/fedora.sh"

while [[ $# -gt 0 ]]; do
	case "$1" in
	--user)
		AGENT_USER="$2"
		shift 2
		;;
	-h | --help)
		echo "Usage: bootstrap/agent/create-user.sh [--user agent]"
		exit 0
		;;
	*)
		echo "Error: unknown argument '$1'." >&2
		exit 1
		;;
	esac
	done

ensure_group "$DEV_GROUP"

if ! id "$AGENT_USER" >/dev/null 2>&1; then
	AGENT_SHELL="$(command -v zsh || command -v bash)"
	run_as_root useradd -m -s "$AGENT_SHELL" -G "$DEV_GROUP" "$AGENT_USER"
else
	ensure_user_in_group "$AGENT_USER" "$DEV_GROUP"
	AGENT_SHELL="$(getent passwd "$AGENT_USER" | cut -d: -f7)"
fi

run_as_root install -d -m 700 -o "$AGENT_USER" -g "$AGENT_USER" "/home/$AGENT_USER/.ssh"

echo "Agent user ready: $AGENT_USER"
echo "Shell: $AGENT_SHELL"
echo "Next: switch to '$AGENT_USER', clone the repo, then run bootstrap/agent/fedora-user.sh"
