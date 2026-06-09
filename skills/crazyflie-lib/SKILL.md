---
name: crazyflie-lib
description: >
  Use this skill when writing Python scripts to connect to a Crazyflie,
  stream log data, or read/write parameters. Triggers on tasks like "write
  a Python script", "connect from Python", "log to file", "stream sensor
  data in Python", or "set a parameter from Python".
---

# Crazyflie Python Library (cflib2)

Use the `cflib2` package for all Python scripting against a Crazyflie.

cflib2 is an async Python library backed by a Rust extension. All I/O is async — scripts use `asyncio`.

The lib lives at `~/code/bitcraze/crazyflie-lib-python-v2`. Examples are in `examples/`.

## Connection

```python
from cflib2 import Crazyflie, LinkContext, FileTocCache

context = LinkContext()
cache = FileTocCache("/tmp/cf_toc_cache")  # omit for no caching
cf = await Crazyflie.connect_from_uri(context, uri, toc_cache=cache)
# ...
await cf.disconnect()
```

`FileTocCache` avoids re-downloading the TOC on every connection — use it when iterating quickly.

## Log API

Log variables are read-only and streamed at a fixed period. Variable names are `group.name` strings (e.g. `stateEstimate.roll`). Use `cf.log().names()` to list all available variables.

```python
log = cf.log()

block = await log.create_block()
await block.add_variable("stateEstimate.x")
await block.add_variable("stateEstimate.roll")
# add more variables...

stream = await block.start(50)  # period in ms; range 10–2550
try:
    while True:
        data = await stream.next()
        print(data.timestamp, data.data)  # data.data is a dict
except KeyboardInterrupt:
    pass
finally:
    await stream.stop()
```

`data.data` is a `dict[str, float|int]` keyed by variable name. `data.timestamp` is milliseconds (Crazyflie clock).

`stream.stop()` returns the `LogBlock` so it can be restarted with a different period.

## Param API

Parameters are runtime-configurable values. Variable names are `group.name` strings. Use `cf.param().names()` to list all.

```python
param = cf.param()

value = await param.get("stabilizer.estimator")
await param.set("stabilizer.estimator", 1)
```

See `${CLAUDE_PLUGIN_ROOT}/skills/crazyflie-firmware/shared/reference.md` for commonly useful log variables and parameters.

## Project Conventions

All examples follow this structure:

```python
import asyncio
from dataclasses import dataclass

import tyro

from cflib2 import Crazyflie, LinkContext

@dataclass
class Args:
    uri: str = "radio://0/80/2M/E7E7E7E7E7"
    """Crazyflie URI"""

async def main() -> None:
    args = tyro.cli(Args)
    context = LinkContext()
    cf = await Crazyflie.connect_from_uri(context, args.uri)
    try:
        # ...
    finally:
        await cf.disconnect()

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
```

- Use `tyro.cli(Args)` with a `@dataclass` for CLI arguments
- Wrap cleanup in `finally` so it runs on both normal exit and exceptions
- Catch `KeyboardInterrupt` at the top level (outside `asyncio.run`) to suppress the traceback
