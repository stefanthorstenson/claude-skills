---
name: crazyflie-firmware-param
description: >
  Use this skill when reading or writing Crazyflie parameters at runtime,
  or adding new parameters to firmware. Triggers on tasks like "set the PID
  gains", "change a parameter", "read a param", "add a parameter", or
  "PARAM_GROUP".
---

# Crazyflie Parameters

Parameters are runtime-configurable values organized as `group.name`.

## Reading and Writing Parameters

```bash
# List all parameters with current values
crazyflie-agent-cli param list

# Read a single parameter
crazyflie-agent-cli param get pid_rate.kp

# Write a parameter
crazyflie-agent-cli param set pid_rate.kp 50
```

A session must be running. If none is active:

```bash
crazyflie-agent-cli start <URI> > /tmp/cf-output.log 2>&1 &
```

## Adding Parameters to Firmware

In the relevant `.c` file:

```c
#include "param.h"

static float myParam = 1.0f;

PARAM_GROUP_START(myModule)
  PARAM_ADD(PARAM_FLOAT, myParam, &myParam)
PARAM_GROUP_STOP(myModule)
```

For read-only parameters:

```c
PARAM_ADD(PARAM_FLOAT | PARAM_RONLY, myParam, &myParam)
```

Available types: `PARAM_UINT8`, `PARAM_UINT16`, `PARAM_UINT32`, `PARAM_INT8`, `PARAM_INT16`, `PARAM_INT32`, `PARAM_FLOAT`.

## Reference

For a table of commonly useful parameters and firmware architecture, read:
`${CLAUDE_PLUGIN_ROOT}/skills/crazyflie-firmware/shared/reference.md`
