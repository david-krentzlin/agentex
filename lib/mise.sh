#!/usr/bin/env bash

MISE_SYSTEM_DATA_DIR_DEFAULT="/usr/local/share/mise"
MISE_SYSTEM_SHARED_BIN_DIR_DEFAULT="${MISE_SYSTEM_DATA_DIR_DEFAULT}/bin"

mise_repo_config_file() {
	local repo_root="$1"
	printf '%s/packages/dev/mise/dot-config/mise/config.toml\n' "$repo_root"
}

trust_mise_config_if_present() {
	local config_file="$1"
	if [[ ! -f "$config_file" ]]; then
		return
	fi

	run_as_root mise trust -y "$config_file"
}

run_mise_system() {
	local repo_root="$1"
	shift

	local config_file
	config_file="$(mise_repo_config_file "$repo_root")"

	run_as_root env \
		MISE_SYSTEM_DATA_DIR="$MISE_SYSTEM_DATA_DIR_DEFAULT" \
		MISE_GLOBAL_CONFIG_FILE="$config_file" \
		PATH="$MISE_SYSTEM_SHARED_BIN_DIR_DEFAULT:$PATH" \
		mise "$@"
}

install_system_mise() {
	install_dnf_packages dnf-plugins-core

	if command -v mise >/dev/null 2>&1; then
		:
	elif run_as_root dnf -y copr enable jdxcode/mise; then
		install_dnf_packages mise
	else
		run_as_root sh -c 'curl -fsSL https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh'
	fi

	run_as_root install -d -m 755 "$MISE_SYSTEM_DATA_DIR_DEFAULT"
	run_as_root install -d -m 755 "$MISE_SYSTEM_SHARED_BIN_DIR_DEFAULT"
}

trust_system_mise_configs() {
	local repo_root="$1"
	local repo_config_file

	repo_config_file="$(mise_repo_config_file "$repo_root")"
	trust_mise_config_if_present "$repo_config_file"

	if [[ -n "${SUDO_HOME:-}" ]]; then
		trust_mise_config_if_present "$SUDO_HOME/.config/mise/config.toml"
	fi
}

read_non_comment_lines() {
	local file_path="$1"
	grep -Ev '^[[:space:]]*(#|$)' "$file_path"
}

install_system_mise_tools() {
	local repo_root="$1"
	run_mise_system "$repo_root" install --system
}

install_system_node_packages() {
	local repo_root="$1"
	local package_file="$2"
	mapfile -t packages < <(read_non_comment_lines "$package_file")
	if [[ ${#packages[@]} -eq 0 ]]; then
		return
	fi
	run_mise_system "$repo_root" exec -- npm install -g "${packages[@]}"
	run_mise_system "$repo_root" reshim
}

install_system_ruby_gems() {
	local repo_root="$1"
	local gem_file="$2"
	mapfile -t gems < <(read_non_comment_lines "$gem_file")
	if [[ ${#gems[@]} -eq 0 ]]; then
		return
	fi
	run_mise_system "$repo_root" exec -- gem install "${gems[@]}"
	run_mise_system "$repo_root" reshim
}

install_system_go_tools() {
	local repo_root="$1"
	local tool_file="$2"
	mapfile -t tools < <(read_non_comment_lines "$tool_file")
	if [[ ${#tools[@]} -eq 0 ]]; then
		return
	fi

	local tool
	for tool in "${tools[@]}"; do
		run_as_root env \
			MISE_SYSTEM_DATA_DIR="$MISE_SYSTEM_DATA_DIR_DEFAULT" \
			MISE_GLOBAL_CONFIG_FILE="$(mise_repo_config_file "$repo_root")" \
			GOBIN="$MISE_SYSTEM_SHARED_BIN_DIR_DEFAULT" \
			PATH="$MISE_SYSTEM_SHARED_BIN_DIR_DEFAULT:$PATH" \
			mise exec -- go install "$tool"
	done
}

coursier_download_url() {
	case "$(uname -m)" in
	x86_64 | amd64)
		printf '%s\n' 'https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz'
		;;
	aarch64 | arm64)
		printf '%s\n' 'https://github.com/coursier/launchers/raw/master/cs-aarch64-pc-linux.gz'
		;;
	*)
		echo "Error: unsupported architecture for coursier: $(uname -m)" >&2
		return 1
		;;
	esac
}

install_system_coursier() {
	local cs_path="$MISE_SYSTEM_SHARED_BIN_DIR_DEFAULT/cs"
	if [[ -x "$cs_path" ]]; then
		return
	fi

	local url
	url="$(coursier_download_url)"
	run_as_root sh -c "curl -fsSL '$url' | gzip -d > '$cs_path'"
	run_as_root chmod 755 "$cs_path"
}

install_system_coursier_apps() {
	local app_file="$1"
	mapfile -t apps < <(read_non_comment_lines "$app_file")
	if [[ ${#apps[@]} -eq 0 ]]; then
		return
	fi

	install_system_coursier
	run_as_root env \
		PATH="$MISE_SYSTEM_SHARED_BIN_DIR_DEFAULT:$PATH" \
		COURSIER_INSTALL_DIR="$MISE_SYSTEM_SHARED_BIN_DIR_DEFAULT" \
		"$MISE_SYSTEM_SHARED_BIN_DIR_DEFAULT/cs" install --install-dir "$MISE_SYSTEM_SHARED_BIN_DIR_DEFAULT" "${apps[@]}"
}
