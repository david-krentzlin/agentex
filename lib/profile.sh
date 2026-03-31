#!/usr/bin/env bash

PROFILE_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$PROFILE_LIB_DIR/.." && pwd)"

# shellcheck source=lib/stow.sh
source "$PROFILE_LIB_DIR/stow.sh"

profile_file_path() {
	local profile_name="$1"
	printf '%s/profiles/%s\n' "$REPO_ROOT" "$profile_name"
}

apply_profile() {
	local profile_name="$1"
	local target_dir="${2:-$HOME}"
	local profile_file

	profile_file="$(profile_file_path "$profile_name")"
	if [[ ! -f "$profile_file" ]]; then
		echo "Error: profile not found: $profile_name" >&2
		return 1
	fi

	while IFS= read -r package_name || [[ -n "$package_name" ]]; do
		if [[ -z "$package_name" || "$package_name" == \#* ]]; then
			continue
		fi

		if [[ ! -d "$REPO_ROOT/packages/$package_name" ]]; then
			echo "Skipping missing package: $package_name"
			continue
		fi

		echo "Applying package: $package_name"
		stow_package "$REPO_ROOT" "packages/$package_name" "$target_dir"
	done <"$profile_file"
}
