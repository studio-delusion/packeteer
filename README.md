# packeteer

A simple buffer description & serdes library

# Why?

Packeteer was created due to there not being any lightweight libraries out there to type safely describe & create buffers.\
Yes, there likely **are** libraries to create and manipulate buffers, although packeteer is as of it's making the only one available that does what it does -\
\- in packeteer, you define the structure of a buffer and simply call a function to serialize / deserialize - both of which provide full types for the structure.

# Installation

1. Add packeteer to your `wally.toml`

```toml
[dependencies]
packeteer = "studio-delusion/packeteer@latest" # Replace latest with the current version
```

2. Run `wally install`

# Usage

As said earlier, you describe the structure of a buffer

```lua
local packeteer = require(path.to.packeteer)

local person_packet = packeteer.describe({
    name = packeteer.string,
    age = packeteer.u8
})
```

and use a function to serialize / deserialize it.

```lua
local serialized = person_packet.serialize({
    name = "John Doe",
    age = 16
})
```

```lua
local deserialized = person_packet.deserialize(serialized)
```

> [!NOTE]\
> `packet.serialize()` returns a buffer.\
> Buffers can be safely stored in `DataStore`s, and safely transmitted over `RemoteEvent`s.

> [!NOTE]\
> `packet.deserialize()` takes in any buffer.
> You can pass it any buffer, and as long as it's valid, it'll spit out correct data.
