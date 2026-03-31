#!/usr/bin/env bash

run_as_root() {
	if [[ "$(id -u)" -eq 0 ]]; then
		"$@"
		return
	fi

	if command -v sudo >/dev/null 2>&1; then
		sudo "$@"
		return
	fi

	echo "Error: root privileges required for: $*" >&2
	return 1
}

require_dnf() {
	if ! command -v dnf >/dev/null 2>&1; then
		echo "Error: this bootstrap expects a Fedora-based system with dnf." >&2
		return 1
	fi
}

install_dnf_packages() {
	require_dnf || return 1
	run_as_root dnf install -y "$@"
}

install_optional_dnf_packages() {
	require_dnf || return 1
	local package_name
	for package_name in "$@"; do
		if ! run_as_root dnf install -y "$package_name"; then
			echo "Skipping optional Fedora package: $package_name" >&2
		fi
	done
}

ensure_group() {
	local group_name="$1"
	if ! getent group "$group_name" >/dev/null 2>&1; then
		run_as_root groupadd "$group_name"
	fi
}

ensure_directory() {
	local path="$1"
	local owner="$2"
	local group="$3"
	local mode="$4"

	run_as_root mkdir -p "$path"
	run_as_root chown "$owner:$group" "$path"
	run_as_root chmod "$mode" "$path"
}

ensure_user_in_group() {
	local user_name="$1"
	local group_name="$2"
	if id -nG "$user_name" | tr ' ' '\n' | grep -Fxq "$group_name"; then
		return
	fi
	run_as_root usermod -a -G "$group_name" "$user_name"
}
