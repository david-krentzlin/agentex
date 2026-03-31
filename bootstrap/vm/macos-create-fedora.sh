#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "Error: bootstrap/vm/macos-create-fedora.sh must be run on macOS." >&2
	exit 1
fi

if ! command -v limactl >/dev/null 2>&1; then
	echo "Error: limactl is required but was not found on PATH." >&2
	exit 1
fi

INSTANCE_NAME="dev"
TRANSFER_DIR="${HOME}/VMTransfer"
TRANSFER_MOUNT="/transfer"

while [[ $# -gt 0 ]]; do
	case "$1" in
	--name)
		INSTANCE_NAME="$2"
		shift 2
		;;
	--transfer-dir)
		TRANSFER_DIR="$2"
		shift 2
		;;
	-h | --help)
		echo "Usage: bootstrap/vm/macos-create-fedora.sh [--name dev] [--transfer-dir ~/VMTransfer]"
		exit 0
		;;
	*)
		echo "Error: unknown argument '$1'." >&2
		exit 1
		;;
	esac
	done

mkdir -p "$TRANSFER_DIR"

if limactl list | awk 'NR > 1 { print $1 }' | grep -Fxq "$INSTANCE_NAME"; then
	echo "Error: Lima instance '$INSTANCE_NAME' already exists." >&2
	exit 1
fi

limactl start \
	--name="$INSTANCE_NAME" \
	--plain \
	--mount-only "${TRANSFER_DIR}:w" \
	--set ".mounts[0].mountPoint = \"${TRANSFER_MOUNT}\"" \
	template:fedora

echo "Fedora VM '$INSTANCE_NAME' created."
echo "Transfer mount: $TRANSFER_DIR -> $TRANSFER_MOUNT"
echo "Enter with: limactl shell --workdir /home/lima.guest $INSTANCE_NAME"
