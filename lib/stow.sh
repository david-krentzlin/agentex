#!/usr/bin/env bash

stow_package() {
	local repo_root="$1"
	local package_name="$2"
	local target_dir="${3:-$HOME}"

	stow \
		--restow \
		--target="$target_dir" \
		--ignore='README.md|Makefile|Brewfile|Brewfile.lock|Ignored' \
		--dotfiles \
		-d "$repo_root" \
		"$package_name"
}
