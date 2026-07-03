# claude-skills

A repository for collecting all Claude skills.

Skills here are loaded by symlinking into `~/.claude/skills/` (via an `~/.agents/skills/` hop) — see `design.md` for how the mechanism works.

## Adding a skill

1. Create a folder under `skills/` with a `SKILL.md` (a `name:` field in its frontmatter, plus a tight `description:` for triggering).
2. Add the folder's path to `skills.json`.
3. Run `./sync-skills.sh`.
4. Restart Claude Code / the VSCode extension so the new skill name is picked up.

## Updating a skill

Just edit its `SKILL.md` (or supporting files). Changes are live immediately — no re-run of `sync-skills.sh` needed unless a skill was added, renamed, or removed.

## Removing / staging a skill

Remove its entry from `skills.json` and run `./sync-skills.sh` — this prunes the symlinks. The folder itself can stay in `skills/`.
