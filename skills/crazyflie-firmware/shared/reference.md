# Crazyflie Firmware Reference

## Firmware Architecture

The firmware is a FreeRTOS application on an STM32F405. Key directories:

- `src/modules/src/` — Core modules (stabilizer, commander, estimator, log, param)
- `src/modules/interface/` — Public headers
- `src/drivers/src/` — Hardware drivers (IMU, barometer, motors)
- `src/hal/src/` — Hardware abstraction layer
- `src/deck/` — Expansion deck drivers
- `src/platform/` — Platform-specific code (CF2, Bolt, etc.)

Key subsystems:
- **Stabilizer** (`stabilizer.c`) — Main control loop running at 1kHz
- **Commander** (`commander.c`) — Receives setpoints from multiple sources
- **State Estimator** (`estimator_kalman.c`) — Kalman filter for position/attitude
- **CRTP** (`crtp.c`) — Communication protocol over radio

## Useful Log Variables

| Variable | Type | Description |
|----------|------|-------------|
| `stateEstimate.roll/pitch/yaw` | float | Attitude in degrees |
| `stateEstimate.x/y/z` | float | Position estimate (m) |
| `stabilizer.roll/pitch/yaw/thrust` | float | Controller outputs |
| `acc.x/y/z` | float | Accelerometer (g) |
| `gyro.x/y/z` | float | Gyroscope (deg/s) |
| `baro.asl` | float | Barometer altitude (m) |
| `pm.vbat` | float | Battery voltage |
| `sys.canfly` | uint8 | System ready flag |

## Useful Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `stabilizer.controller` | uint8 | Active controller (0=PID, 1=Mellinger) |
| `stabilizer.estimator` | uint8 | Active estimator (0=complementary, 1=Kalman) |
| `pid_rate.kp/ki/kd` | float | Rate PID gains |
| `pid_attitude.kp/ki/kd` | float | Attitude PID gains |

## Troubleshooting

### Crazyflie won't connect after flash

The firmware might have crashed before the radio stack initialized. This is the most dangerous failure mode because you lose radio access.

1. Run `crazyflie-agent-cli recover`
2. If the CLI can still reach the Crazyflie, it will reset it to bootloader mode
3. If not, ask the user to manually put it in bootloader mode: turn it off, hold the power button for 3 seconds until the blue LEDs start blinking
4. Once in bootloader mode, flash a known-good firmware with `--cold`

### Avoiding radio-bricking

These files are critical for radio communication — modifying them incorrectly can make the Crazyflie unreachable:

- `src/modules/src/crtp.c`
- `src/hal/src/radiolink.c`
- `src/drivers/src/nrf24*`
- `src/init/`
- `src/modules/src/system.c`

Warn the user before modifying any of these, and consider making a backup flash image first.

### Build failures

- Missing toolchain: `arm-none-eabi-gcc` must be installed
- Submodules not initialized: `git submodule update --init --recursive`
- Config not set: run `make cf2_defconfig` first
