# Claude Skills – Design Decisions

## Skill structure and supporting content

**Decision: Narrow skills per activity, with shared reference content in a non-skill file.**

- Supporting content (architecture map, useful log/param tables, troubleshooting) lives in `skills/firmware/shared/reference.md` — not a skill itself.
- Each `SKILL.md` references `${CLAUDE_PLUGIN_ROOT}/skills/firmware/shared/reference.md` when needed.
- Single source of truth, no duplication across skills.

**Structure:**
```
skills/
  firmware/
    build/SKILL.md
    flash/SKILL.md
    log/SKILL.md
    param/SKILL.md
    shared/
      reference.md
```

## Skill granularity and structure

**Decision: Narrow/focused skills, organized with folder namespaces, explicitly registered in `plugin.json`.**

- Each skill triggers only in its specific context (tight `description` frontmatter).
- Folders are organizational namespaces for the repo maintainer — not visible to Claude.
- Inspired by the mattpocock/skills pattern: skills registered explicitly in `plugin.json` rather than relying on auto-discovery, which enables staging and deprecation simply by omitting entries from the manifest.
- Folder nesting is for grouping only — a folder either contains a `SKILL.md` (it is a skill) or subdirectories (it is a namespace), not both.

**Example structure:**
```
skills/
  firmware/
    flash/SKILL.md
    build/SKILL.md
    log-param/SKILL.md
  cflib/SKILL.md
  swarm/SKILL.md
```
