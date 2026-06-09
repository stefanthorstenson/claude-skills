---
name: crazyflie-firmware-build
description: >
  Use this skill when building or compiling Crazyflie firmware, configuring
  the build system, or diagnosing build failures. Triggers on tasks like
  "build the firmware", "compile", "make", "set up the toolchain", or
  "enable/disable a feature in the build config".
---

# Building Crazyflie Firmware

The Crazyflie firmware uses Kbuild (Linux kernel build system).

## Build Steps

```bash
cd <firmware-directory>
make cf2_defconfig    # Only needed once, or after config changes
make -j$(nproc)       # Produces build/cf2.bin
```

To change build configuration (enable/disable features):

```bash
make menuconfig       # Interactive config menu
# or edit .config directly
```

## Toolchain Check

Before building, verify the ARM toolchain is available:

```bash
which arm-none-eabi-gcc
```

If missing, it must be installed (e.g. `sudo apt install gcc-arm-none-eabi` on Ubuntu).

If submodules are missing:

```bash
git submodule update --init --recursive
```

## Reference

For firmware architecture and directory layout, read:
`${CLAUDE_PLUGIN_ROOT}/skills/firmware/shared/reference.md`
