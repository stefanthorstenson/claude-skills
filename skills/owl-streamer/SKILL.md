---
name: owl-streamer
description: >
  Use this skill when the user writes "run owl-streamer". Runs the
  owl-streamer for the camera deck from the owl-streamer repo.
  An optional number argument identifies the camera deck individual (e.g. "run owl-streamer 5").
---

# Running owl-streamer

The owl-streamer repo is at `~/code/bitcraze/owl-streamer`.

Run from that directory:

```bash
cd ~/code/bitcraze/owl-streamer
cargo run --release -- --ip <ip-address>
```

## Camera deck number

If the user provides a number (e.g. "run owl-streamer 5"), use it as the camera deck individual number to look up the IP address below.
If no number is given, ask the user which camera deck they want to use.

## Network detection

Detect the current network automatically before looking up the IP:

```bash
nmcli -t -f name,type connection show --active | grep -E '802-11-wireless|802-3-ethernet' | cut -d: -f1
```

This returns the connection name (e.g. `QuatroGansos` or `Bitcraze`) for the active WiFi or Ethernet connection. Use it to select the correct IP address from the table below.
If the command fails, returns empty output, or the name does not match any known network, ask the user which network they are on (listing the known networks from the table below) before proceeding.

## Camera deck IP addresses

Camera deck #5:

| Network        | IP address      |
|----------------|-----------------|
| QuatroGansos   | 192.168.68.128  |
| Bitcraze       | 192.168.6.88    |

To add a new camera deck individual, add a new section here following the same format.
