# packeteer

A simple buffer description & serdes library

# Installation

1. Add packeteer to your `wally.toml`

```toml
[dependencies]
packeteer = "studio-delusion/packteer@latest" # Replace latest with the current version
```

2. Run `wally install`

Alternatively, you can pull a rbxm file from Github releases.

# Usage

Describe your buffer

```lua
local packteer = require(?)

local person = packteer.describe({
    name = packeteer.string(20),
    age = packeteer.u8,
})
```

and serdes

```lua
local serialized = person.serialize({
    name = "John Doe",
    age = 21,
})
```

```lua
local deserialized = person.deserialize(serialized)
```
