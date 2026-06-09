---
name: crazyflie-firmware-log
description: >
  Use this skill when streaming log variables from a Crazyflie, adding new
  log variables to firmware, or inspecting sensor and state data over radio.
  Triggers on tasks like "log the roll angle", "stream sensor data", "add a
  log variable", "what is the battery voltage", or "LOG_GROUP".
---

# Crazyflie Log Variables

Log variables are read-only sensor data and internal state streamed at a configurable rate.

## Streaming Log Data

```bash
# List all available variables
crazyflie-agent-cli log list

# Stream specific variables at 10 Hz (data appears in the session output file)
crazyflie-agent-cli log start stateEstimate.roll stateEstimate.pitch pm.vbat --rate 10

# Read the streamed data
grep "\[log " /tmp/cf-output.log | tail -10

# Stop streaming
crazyflie-agent-cli log stop
```

A session must be running to stream log data. If none is active:

```bash
crazyflie-agent-cli start <URI> > /tmp/cf-output.log 2>&1 &
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

After building and flashing, `myModule.myVar` appears in `log list`.

Available types: `LOG_UINT8`, `LOG_UINT16`, `LOG_UINT32`, `LOG_INT8`, `LOG_INT16`, `LOG_INT32`, `LOG_FLOAT`, `LOG_FP16`.

## Reference

For a table of commonly useful log variables and firmware architecture, read:
`${CLAUDE_PLUGIN_ROOT}/skills/crazyflie-firmware/shared/reference.md`
