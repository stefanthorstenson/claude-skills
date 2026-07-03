#!/usr/bin/env bash
# Creates/refreshes/prunes the symlink chain for skills listed in skills.json:
#   repo skill folder <- ~/.agents/skills/<name> <- ~/.claude/skills/<name>
# <name> is read from each skill's own SKILL.md frontmatter.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$HOME/.agents/skills"
CLAUDE_DIR="$HOME/.claude/skills"
MANIFEST="$REPO_DIR/skills.json"

mkdir -p "$AGENTS_DIR" "$CLAUDE_DIR"

declare -A name_to_dir

while IFS= read -r rel_path; do
    skill_dir="$REPO_DIR/${rel_path#./}"
    skill_md="$skill_dir/SKILL.md"

    if [[ ! -f "$skill_md" ]]; then
        echo "error: $rel_path has no SKILL.md" >&2
        exit 1
    fi

    name="$(awk '/^---$/{c++; next} c==1 && /^name:/{print $2; exit}' "$skill_md")"
    if [[ -z "$name" ]]; then
        echo "error: $skill_md has no 'name:' in its frontmatter" >&2
        exit 1
    fi

    if [[ -n "${name_to_dir[$name]:-}" ]]; then
        echo "error: name '$name' is used by both ${name_to_dir[$name]} and $skill_dir" >&2
        exit 1
    fi
    name_to_dir["$name"]="$skill_dir"
done < <(jq -r '.[]' "$MANIFEST")

link() {
    local target="$1" link_path="$2"
    if [[ -L "$link_path" ]]; then
        [[ "$(readlink "$link_path")" == "$target" ]] && return
        rm "$link_path"
    elif [[ -e "$link_path" ]]; then
        echo "error: $link_path exists and is not a symlink, refusing to overwrite" >&2
        exit 1
    fi
    ln -s "$target" "$link_path"
    echo "linked $link_path -> $target"
}

for name in "${!name_to_dir[@]}"; do
    link "${name_to_dir[$name]}" "$AGENTS_DIR/$name"
    link "$AGENTS_DIR/$name" "$CLAUDE_DIR/$name"
done

# Prune symlinks that point into this repo but are no longer in skills.json
for dir in "$AGENTS_DIR" "$CLAUDE_DIR"; do
    for entry in "$dir"/*; do
        [[ -L "$entry" ]] || continue
        name="$(basename "$entry")"
        real="$(readlink -f "$entry" 2>/dev/null || true)"
        [[ "$real" == "$REPO_DIR"/* ]] || continue
        [[ -n "${name_to_dir[$name]:-}" ]] && continue
        rm "$entry"
        echo "removed stale $entry"
    done
done
