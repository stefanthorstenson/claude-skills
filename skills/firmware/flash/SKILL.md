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
which crazyflie-agent-cli
```

If not found, ask the user before installing:
> "I need `crazyflie-agent-cli` to flash the Crazyflie. It can be installed with `cargo install --git https://github.com/ataffanel/crazyflie-agent-cli`. Want me to install it?"

Ask for the radio URI if unknown (e.g. `radio://0/80/2M/E7E7E7E7E7`). If unsure, scan:

```bash
crazyflie-agent-cli scan
```

Always prefer a URI the user provides over scan results — radio leakage can cause scan to pick up adjacent channels.

## Session Management

Keep a session running to see console output and log data:

```bash
crazyflie-agent-cli start <URI> > /tmp/cf-output.log 2>&1 &
```

Check output:

```bash
grep "\[console\]" /tmp/cf-output.log | tail -20
grep "\[error\]" /tmp/cf-output.log
```

Stop the session:

```bash
crazyflie-agent-cli stop
```

## Flashing

The flash command stops any running session, reboots into bootloader, flashes, then reboots:

```bash
crazyflie-agent-cli flash build/cf2.bin --uri radio://0/80/2M/E7E7E7E7E7
```

After flashing, restart the session:

```bash
crazyflie-agent-cli start <URI> > /tmp/cf-output.log 2>&1 &
```

If the Crazyflie is already in bootloader mode:

```bash
crazyflie-agent-cli flash build/cf2.bin --cold
```

Reboot without flashing:

```bash
crazyflie-agent-cli reset --uri <URI>
```

## Recovery

If the Crazyflie is unresponsive after a flash:

```bash
crazyflie-agent-cli recover
```

If the CLI cannot reach it, ask the user:
> "The Crazyflie appears to be unresponsive over radio. Could you please put it in bootloader mode? Turn it off, then hold the power button for about 3 seconds until the blue LEDs start blinking. Let me know when it's ready."

Then flash a known-good firmware with `--cold`.

For radio-critical files to avoid and full troubleshooting guidance, read:
`${CLAUDE_PLUGIN_ROOT}/skills/firmware/shared/reference.md`
