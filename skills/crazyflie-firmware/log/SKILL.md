---
name: crazyflie-firmware-log
description: >
  Use this skill when streaming log variables using cfcli, or adding new log
  variables to Crazyflie firmware C code. Triggers on tasks like "what cfcli
  command streams roll", "add a log variable to firmware", "LOG_GROUP", or
  "what is the battery voltage". For Python scripting, use the crazyflie-lib
  skill instead.
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

## Reference

For a table of commonly useful log variables and firmware architecture, read:
`${CLAUDE_PLUGIN_ROOT}/skills/crazyflie-firmware/shared/reference.md`
