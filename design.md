# Claude Skills – Design Decisions

## Loading mechanism

**Decision: Each skill folder is symlinked into `~/.claude/skills/`, via an `~/.agents/skills/` hop.**

- Real files live in this repo. `~/.agents/skills/<name>` symlinks to the skill's folder here; `~/.claude/skills/<name>` symlinks to that. Same mechanism every other personal skill on this machine uses.
- Editing a skill's `SKILL.md` is live immediately — no cache, no update step.
- Adding a new skill name requires a Claude Code / VSCode-extension session restart to be picked up; editing an already-registered skill's content does not.
- `sync-skills.sh` (repo root) creates/refreshes/prunes this symlink chain from `skills.json` — see "Skill granularity and structure" below.

## Skill structure and supporting content

**Decision: Narrow skills per activity, with shared reference content in a non-skill file.**

- Supporting content (architecture map, useful log/param tables, troubleshooting) lives in `skills/crazyflie-firmware/shared/reference.md` — not a skill itself.
- Each `SKILL.md` that needs it references the shared file with a relative path, e.g. `../shared/reference.md`. This resolves correctly through the symlink chain: POSIX resolves `..` against the real target directory, not the symlink's location.
- Single source of truth, no duplication across skills.

**Structure:**
```
skills/
  crazyflie-firmware/
    build/SKILL.md
    flash/SKILL.md
    log/SKILL.md
    param/SKILL.md
    shared/
      reference.md
```

## Skill granularity and structure

**Decision: Narrow/focused skills, organized with folder namespaces, explicitly registered in `skills.json`.**

- Each skill triggers only in its specific context (tight `description` frontmatter).
- Folders are organizational namespaces for the repo maintainer — not visible to Claude.
- Skills are registered explicitly in `skills.json` (a bare array of skill folder paths) rather than relying on auto-discovery. `sync-skills.sh` reads this file and only symlinks the paths listed — staging or deprecating a skill is just adding or removing a line, the folder can stay in place.
- The symlink name for each skill is derived from that skill's own `SKILL.md` frontmatter `name:` field — `skills.json` doesn't repeat it, so the two can't drift out of sync.
- Folder nesting is for grouping only — a folder either contains a `SKILL.md` (it is a skill) or subdirectories (it is a namespace), not both.

**Example structure:**
```
skills/
  crazyflie-firmware/
    flash/SKILL.md
    build/SKILL.md
    log/SKILL.md
    param/SKILL.md
  crazyflie-lib/SKILL.md
  swarm/SKILL.md
```
