#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEV_GROUP="devvm"
DEV_USER="${SUDO_USER:-$USER}"

# shellcheck source=lib/fedora.sh
source "$REPO_ROOT/lib/fedora.sh"
# shellcheck source=lib/mise.sh
source "$REPO_ROOT/lib/mise.sh"

NODE_PACKAGES_FILE="$REPO_ROOT/packages/dev/lsps/node-packages.txt"
RUBY_GEMS_FILE="$REPO_ROOT/packages/dev/lsps/ruby-gems.txt"
GO_TOOLS_FILE="$REPO_ROOT/packages/dev/lsps/go-tools.txt"
COURSIER_APPS_FILE="$REPO_ROOT/packages/dev/lsps/coursier-apps.txt"

install_dnf_packages \
	git \
	gzip \
	stow \
	zsh \
	tmux \
	neovim \
	ripgrep \
	fd-find \
	jq \
	make \
	gcc \
	gcc-c++ \
	curl \
	ca-certificates \
	openssh-clients \
	tar \
	unzip

install_optional_dnf_packages \
	starship \
	bat \
	eza \
	fzf \
	zoxide \
	atuin \
	lazygit \
	yazi \
	glow \
	helm

ensure_group "$DEV_GROUP"
ensure_user_in_group "$DEV_USER" "$DEV_GROUP"
ensure_directory /workspaces root "$DEV_GROUP" 2775

install_system_mise
trust_system_mise_configs "$REPO_ROOT"
install_system_mise_tools "$REPO_ROOT"
install_system_node_packages "$REPO_ROOT" "$NODE_PACKAGES_FILE"
install_system_ruby_gems "$REPO_ROOT" "$RUBY_GEMS_FILE"
install_system_go_tools "$REPO_ROOT" "$GO_TOOLS_FILE"
install_system_coursier_apps "$COURSIER_APPS_FILE"

echo "Fedora system bootstrap complete."
echo "Shared workspace root: /workspaces"
echo "Shared group: $DEV_GROUP"
echo "Dev user in shared group: $DEV_USER"
echo "System mise data dir: $MISE_SYSTEM_DATA_DIR_DEFAULT"
echo "Next: run bootstrap/dev/fedora-user.sh as the dev user"
