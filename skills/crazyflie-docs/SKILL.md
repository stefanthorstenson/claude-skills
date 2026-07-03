---
name: crazyflie-docs
description: >
  Use this skill when answering questions about how the Crazyflie ecosystem
  works, or when a claim should be verified against official documentation
  instead of guessed from training data. Triggers on tasks like "how does X
  work", "check the docs for Y", "what does the documentation say about Z",
  "look up the CRTP protocol", "read the docs", or questions about hardware
  decks, the Loco Positioning System, firmware architecture, or client/library
  usage. Searches the locally cloned bitcraze-website and per-repo docs/
  folders under ~/code/bitcraze — do not answer ecosystem questions from
  memory alone when these sources are available.
---

# Crazyflie Ecosystem Documentation

All Bitcraze documentation is cloned locally under `~/code/bitcraze/`. Prefer
grepping these sources over answering from memory — they reflect the exact
version checked out on disk, not the possibly-stale published version.

There are two kinds of doc source:

## 1. bitcraze-website — user-facing docs (bitcraze.io/documentation)

`~/code/bitcraze/bitcraze-website/src/documentation/`

- `tutorials/` — getting-started guides per product/deck
- `hardware/<deck-or-product>/` — hardware specs, pinouts, mounting
- `system/` — ecosystem architecture, protocols, positioning systems overview
- `repository/index.md` — index of every repo with a link to its own docs (see below); has no content of its own

This is the right place for "how do I set up X", "what hardware does Y need", or ecosystem-level architecture questions.

## 2. Per-repo docs/ — technical/developer docs

Each product repo carries its own `docs/` folder (markdown with `title`/`page_id` frontmatter), published at `bitcraze.io/documentation/repository/<repo>/master/`. These cover build instructions, internal architecture, APIs, and protocols specific to that codebase:

| Repo | docs/ covers |
|---|---|
| `crazyflie-firmware` | STM32 firmware: building/flashing, functional areas (loco positioning, memory subsystem, deck protocol), development guides, API |
| `crazyflie-firmware-experimental` | Experimental firmware features |
| `crazyflie2-nrf-firmware` | NRF51 firmware: radio, power management, ST-link protocol |
| `crazyradio2-firmware` | Crazyradio 2.0 firmware |
| `crazyflie-clients-python` | cfclient (Python GUI client) usage and internals |
| `crazyflie-lib-python` | cflib (Python library, v1) |
| `crazyflie-simulation` | Simulation environment |
| `lps-node-firmware` | Loco Positioning Node firmware, LPS setup |
| `camera-deck-firmware` | Camera deck firmware |
| `cfcli` | cfcli tool usage |
| `toolbelt` | toolbelt usage |

Repos without a `docs/` folder (check the code/README instead): `crazyflie-lib-python-v2`, `lps-tools`, `crazyflie-lib-rs`, `crazyradio-rs`, `crazyflie-link-rs`, `crazyflie-demos`.

## Search strategy

1. Grep across all doc directories at once for the keyword:
   ```bash
   grep -rli "keyword" ~/code/bitcraze/bitcraze-website/src/documentation ~/code/bitcraze/*/docs
   ```
2. Read the full matching file(s) — don't rely on grep context lines alone, these docs cross-reference each other.
3. If the question is about *why* code behaves a certain way and no doc covers it, say so explicitly rather than guessing — then fall back to reading the source.
4. Prefer `bitcraze-website` for anything user-facing (setup, hardware, "how do I..."); prefer the specific repo's `docs/` for implementation/protocol/API detail.
