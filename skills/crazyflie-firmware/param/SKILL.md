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
cfcli param list

# Read a single parameter
cfcli param get pid_rate.kp

# Write a parameter
cfcli param set pid_rate.kp 50

# Persist a parameter value to EEPROM (survives reboot)
cfcli param store pid_rate.kp

# Revert a stored parameter to firmware default
cfcli param clear pid_rate.kp
```

`cfcli` connects per-command — no background session is needed. To use a specific URI:

```bash
cfcli -u radio://0/80/2M/E7E7E7E7E7 param set pid_rate.kp 50
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
