---
name: crazyflie-firmware-flash
description: >
  Use this skill when flashing firmware to a Crazyflie, rebooting it,
  recovering from an unresponsive state, or managing the radio session
  lifecycle. Triggers on tasks like "flash the firmware", "upload to the
  drone", "the Crazyflie is not responding", "recover", or "bootloader".
---

# Flashing Crazyflie Firmware

## Prerequisites

Verify the CLI is available:

```bash
which cfcli
```

If not found, ask the user before installing:
> "I need `cfcli` to flash the Crazyflie. It can be installed with `cargo install cfcli`. Want me to install it?"

## URI Registry

A CSV registry of known Crazyflies is at `/home/stefan/projects/crazyflie-uris.csv`. Columns: `Address` (full `radio://` URI), `Type` (platform type), `Notes` (free-text description).

When the user identifies a Crazyflie by address suffix (e.g. `FACECAFE01`) or by description (e.g. `Brushless`), read the CSV and match against all columns to resolve the full URI and Type. Use that URI with `-u` for all commands. If no match is found, tell the user and fall back to scan.

### Type → Binary mapping

Use the firmware binary from `build/` based on the `Type` column:

| Type                 | Binary          |
|----------------------|-----------------|
| Crazyflie 2.0        | `cf2.bin`       |
| Crazyflie 2.1        | `cf2.bin`       |
| Crazyflie Brushless  | `cf21bl.bin`    |

## URI Management

`cfcli` is stateless — each command connects independently. The selected URI is saved in local settings and reused automatically.

If the Crazyflie is connected via USB, select it directly:

```bash
cfcli select --from-usb
```

Scan for available Crazyflies over radio:

```bash
cfcli scan
```

Select and save a URI for future commands (interactive):

```bash
cfcli select
```

To override the saved URI for a single command, use `-u`:

```bash
cfcli -u radio://0/80/2M/E7E7E7E7E7 <command>
```

Always prefer a URI the user provides over scan results — radio leakage can cause scan to pick up adjacent channels.

## Console Output

View the Crazyflie's console (CRTP console log):

```bash
cfcli console
```

To preserve console output across multiple connections, pass `-p` as a global flag to any command. The saved output is printed the next time `cfcli console` is run:

```bash
cfcli -p bootload flash --bin stm32-fw=build/cf2.bin
cfcli console   # shows console output captured during and after flash
```

## Flashing

Flash a local firmware binary to the STM32 target:

```bash
cfcli bootload flash --bin stm32-fw=build/cf2.bin
```

With an explicit URI:

```bash
cfcli -u radio://0/80/2M/E7E7E7E7E7 bootload flash --bin stm32-fw=build/cf2.bin
```

If the Crazyflie is already in bootloader mode (cold boot):

```bash
cfcli bootload flash --bin stm32-fw=build/cf2.bin --cold
```

Reboot without flashing:

```bash
cfcli platform reboot
```

## Recovery

If the Crazyflie is unresponsive after a flash, try rebooting it:

```bash
cfcli platform reboot
```

If the CLI cannot reach it, ask the user:
> "The Crazyflie appears to be unresponsive over radio. Could you please put it in bootloader mode? Turn it off, then hold the power button for about 3 seconds until the blue LEDs start blinking. Let me know when it's ready."

Then flash a known-good firmware with `--cold`:

```bash
cfcli bootload flash --bin stm32-fw=known-good.bin --cold
```

For radio-critical files to avoid and full troubleshooting guidance, read:
`${CLAUDE_PLUGIN_ROOT}/skills/crazyflie-firmware/shared/reference.md`
