--!nocheck
--!native
--!optimize 2
local function uuid(): string
	math.randomseed(os.clock())

	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and math.random(0, 0xf) or math.random(8, 0xb)
		return string.format("%x", v)
	end)
end

local packeteer = require("../lib/init")

local packet = packeteer.define({
	u8 = packeteer.u8,
	i8 = packeteer.i8,
	u16 = packeteer.u16,
	i16 = packeteer.i16,
	u32 = packeteer.u32,
	i32 = packeteer.i32,
	f32 = packeteer.f32,
	f64 = packeteer.f64,
	boolean = packeteer.boolean,
	vector3 = packeteer.vector3,
	nothing = packeteer.nothing,

	string = packeteer.string(36),

	optional = packeteer.optional(packeteer.u8),
	array = packeteer.array(packeteer.u8),
	map = packeteer.map(packeteer.string(36), packeteer.u8),
	struct = packeteer.struct({
		a = packeteer.string(36),
		b = packeteer.u8,
	}),
})

local function fuzz()
	local u8 = math.random(0, 255)
	local i8 = math.random(-128, 127)
	local u16 = math.random(0, 2 ^ 16)
	local i16 = math.random(-(2 ^ 15 - 1), 2 ^ 15 - 1)
	local u32 = math.random(0, 2 ^ 26)
	local i32 = math.random(-(2 ^ 20), 2 ^ 20)
	local f32 = math.random(1, 25565)
	local f64 = math.random(1, 25565)
	local bool = if math.random(0, 1) == 0 then false else true
	local vec3 = vector(math.random(1, 25565), math.random(1, 25565), math.random(1, 25565))
	local nothing = nil

	local str = uuid()

	local optional = if math.random(0, 1) == 0 then math.random(0, 255) else nil

	local array = {}
	for _ = 1, 500 do
		table.insert(array, math.random(0, 255))
	end

	local map = {}
	for _ = 1, 500 do
		local guid = uuid()
		map[guid] = math.random(0, 255)
	end

	local struct = {
		a = uuid(),
		b = math.random(0, 255),
	}

	return {
		u8 = u8,
		i8 = i8,
		u16 = u16,
		i16 = i16,
		u32 = u32,
		i32 = i32,
		f32 = f32,
		f64 = f64,
		boolean = bool,
		vector3 = vec3,
		nothing = nothing,

		string = str,

		optional = optional,
		array = array,
		map = map,
		struct = struct,
	}
end

return {
	packet = packet,
	fuzz = fuzz,
}
