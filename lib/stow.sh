#!/usr/bin/env bash

stow_package() {
	local repo_root="$1"
	local package_path="$2"
	local target_dir="${3:-$HOME}"
	local stow_dir
	local stow_package_name

	stow_dir="$(dirname "$repo_root/$package_path")"
	stow_package_name="$(basename "$package_path")"

	stow \
		--restow \
		--no-folding \
		--target="$target_dir" \
		--ignore='README.md|Makefile|Brewfile|Brewfile.lock|Ignored|node-packages\.txt|ruby-gems\.txt|go-tools\.txt|coursier-apps\.txt' \
		--dotfiles \
		-d "$stow_dir" \
		"$stow_package_name"
}
