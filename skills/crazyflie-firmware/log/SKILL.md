---
name: crazyflie-firmware-log
description: >
  Use this skill when streaming log variables using cfcli, adding new log
  variables to Crazyflie firmware C code, or creating cfclient log block JSON
  config files. Triggers on tasks like "what cfcli command streams roll",
  "add a log variable to firmware", "LOG_GROUP", "what is the battery voltage",
  or "create a log block". For Python scripting, use the crazyflie-lib skill
  instead.
---

# Crazyflie Log Variables

Log variables are read-only sensor data and internal state streamed at a configurable rate.

## Streaming Log Data

```bash
# List all available variables
cfcli log list

# Stream specific variables at 10 Hz (period = 100 ms); Ctrl+C to stop
cfcli log print stateEstimate.roll,stateEstimate.pitch,pm.vbat --period 100

# Stream with CSV output for scripting
cfcli --csv log print stateEstimate.roll,stateEstimate.pitch,pm.vbat --period 100
```

`cfcli log print` connects, streams directly to stdout, and disconnects on Ctrl+C. No background session is needed.

To use a specific URI:

```bash
cfcli -u radio://0/80/2M/E7E7E7E7E7 log print stateEstimate.roll --period 100
```

## Adding Log Variables to Firmware

In the relevant `.c` file:

```c
#include "log.h"

static float myValue;

LOG_GROUP_START(myModule)
  LOG_ADD(LOG_FLOAT, myVar, &myValue)
LOG_GROUP_STOP(myModule)
```

After building and flashing, `myModule.myVar` appears in `cfcli log list`.

Available types: `LOG_UINT8`, `LOG_UINT16`, `LOG_UINT32`, `LOG_INT8`, `LOG_INT16`, `LOG_INT32`, `LOG_FLOAT`, `LOG_FP16`.

## Log Block Size Limit

Each log block is limited to **26 bytes** of payload per CRTP packet. Variable sizes:

| Type | Bytes |
|------|-------|
| `LOG_FLOAT` / `LOG_INT32` / `LOG_UINT32` | 4 |
| `LOG_INT16` / `LOG_UINT16` / `LOG_FP16` | 2 |
| `LOG_INT8` / `LOG_UINT8` | 1 |

A block with 6 floats uses 24 bytes (fits). 7 floats = 28 bytes (does not fit — split across two blocks).

## cfclient Log Block JSON Files

cfclient loads log block configs from `~/.config/cfclient/log/`. Two subdirectories:
- `local_synced/` — general reusable blocks
- `project_specific/` — project-specific blocks

Each file defines one log block:

```json
{
  "logconfig": {
    "logblock": {
      "name": "my_block",
      "period": 100,
      "variables": [
        {
          "name": "stateEstimate.x",
          "stored_as": "",
          "fetch_as": "float",
          "type": "TOC"
        }
      ]
    }
  }
}
```

- `period` is in milliseconds (100 = 10 Hz)
- `fetch_as` matches the firmware type: `float`, `uint8_t`, `uint16_t`, `int32_t`, etc.
- `stored_as` is typically left as `""` (fetch from TOC)
- `type` is always `"TOC"` for firmware log variables

## Reference

For a table of commonly useful log variables and firmware architecture, read:
`${CLAUDE_PLUGIN_ROOT}/skills/crazyflie-firmware/shared/reference.md`
