#!/bin/sh
# Place the default agent instructions in a repository's .claude/ticket-to-pr/,
# or update them on a later run without touching files the repository edited
# or deleted. Usage: install.sh <plugin-root> <repo-root>
set -eu

[ "$#" -eq 2 ] || { echo "usage: install.sh <plugin-root> <repo-root>" >&2; exit 2; }
plugin_root=$1
repo_root=$2

src_dir="$plugin_root/defaults/agents"
base="$repo_root/.claude/ticket-to-pr"
dst_dir="$base/agents"
manifest="$base/.installed"
[ -d "$src_dir" ] || { echo "error: no defaults at $src_dir" >&2; exit 1; }

if command -v sha256sum >/dev/null 2>&1; then
  hash() { sha256sum "$1" | cut -d ' ' -f 1; }
else
  hash() { shasum -a 256 "$1" | cut -d ' ' -f 1; }
fi

# The hash recorded for a file at the last install, or nothing.
recorded() {
  [ -f "$manifest" ] || return 0
  awk -v f="$1" '$2 == f { print $1 }' "$manifest"
}

version=$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' \
  "$plugin_root/.claude-plugin/plugin.json" | head -n 1)

mkdir -p "$dst_dir"
new_manifest="$manifest.tmp.$$"
echo "version $version" > "$new_manifest"

for src in "$src_dir"/*.md; do
  name="agents/$(basename "$src")"
  dst="$base/$name"
  src_hash=$(hash "$src")
  old_hash=$(recorded "$name")

  if [ ! -e "$dst" ]; then
    if [ -n "$old_hash" ]; then
      echo "skipped $name: deleted in this repository"
      echo "$old_hash $name" >> "$new_manifest"
      continue
    fi
    cp "$src" "$dst"
    echo "added $name"
    echo "$src_hash $name" >> "$new_manifest"
    continue
  fi

  dst_hash=$(hash "$dst")
  if [ "$dst_hash" = "$src_hash" ]; then
    echo "unchanged $name"
    echo "$src_hash $name" >> "$new_manifest"
  elif [ -n "$old_hash" ] && [ "$dst_hash" = "$old_hash" ]; then
    cp "$src" "$dst"
    echo "updated $name"
    echo "$src_hash $name" >> "$new_manifest"
  else
    echo "kept $name: edited in this repository; compare with: diff -u '$dst' '$src'"
    if [ -n "$old_hash" ]; then echo "$old_hash $name" >> "$new_manifest"; fi
  fi
done

mv "$new_manifest" "$manifest"
echo "installed ticket-to-pr-lite $version defaults in $base"
