local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local packeteer = require(ReplicatedStorage.Packages.packeteer)

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
	string = packeteer.string,
	vector3 = packeteer.vector3,

	optional = packeteer.optional(packeteer.u8),
	array = packeteer.array(packeteer.u8),
	map = packeteer.map(packeteer.string, packeteer.u8),
	struct = packeteer.struct({
		a = packeteer.string,
		b = packeteer.u8,
	}),
})

local times = {}
local worst = nil
local best = nil

for _ = 1, 1000 do
	local start = os.clock()

	local u8 = math.random(0, 255)
	local i8 = math.random(-128, 127)
	local u16 = math.random(0, 2 ^ 16)
	local i16 = math.random(-(2 ^ 15 - 1), 2 ^ 15 - 1)
	local u32 = math.random(0, 2 ^ 26)
	local i32 = math.random(-(2 ^ 20), 2 ^ 20)
	local f32 = math.random(1, 25565)
	local f64 = math.random(1, 25565)
	local bool = if math.random(0, 1) == 0 then false else true
	local str = HttpService:GenerateGUID(false)
	local vec3 = Vector3.new(math.random(1, 25565), math.random(1, 25565), math.random(1, 25565))

	local optional = if math.random(0, 1) == 0 then math.random(0, 255) else nil

	local array = {}
	for _ = 1, 500 do
		table.insert(array, math.random(0, 255))
	end

	local map = {}
	for _ = 1, 500 do
		local guid = HttpService:GenerateGUID(false)
		map[guid] = math.random(0, 255)
	end

	local struct = {
		a = HttpService:GenerateGUID(false),
		b = math.random(0, 255),
	}

	local ser = packet.serialize({
		u8 = u8,
		i8 = i8,
		u16 = u16,
		i16 = i16,
		u32 = u32,
		i32 = i32,
		f32 = f32,
		f64 = f64,
		boolean = bool,
		string = str,
		vector3 = vec3,

		optional = optional,
		array = array,
		map = map,
		struct = struct,
	})

	local des = packet.deserialize(ser)

	assert(des.u8 == u8, "des.u8 != u8")
	assert(des.i8 == i8, "des.i8 != i8")
	assert(des.u16 == u16, "des.u16 != u16")
	assert(des.i16 == i16, "des.i16 != i16")
	assert(des.u32 == u32, "des.u32 != u32")
	assert(des.i32 == i32, "des.i32 != i32")
	assert(des.f32 == f32, "des.f32 != f32")
	assert(des.f64 == f64, "des.f64 != f64")
	assert(des.boolean == bool, "des.boolean != bool")
	assert(des.string == str, "des.string != str")
	assert(des.vector3 == vec3, "des.vector3 != vec3")

	assert(des.optional == optional, "des.optional != optional")

	for k, v in des.array do
		assert(v == array[k], "des.array != array")
	end

	for k, v in des.map do
		assert(v == map[k], "des.map != map")
	end

	assert(des.struct.a == struct.a, "des.struct.a != struct.a")
	assert(des.struct.b == struct.b, "des.struct.b != struct.b")

	local _end = os.clock()
	local took = _end - start
	table.insert(times, took)

	if not worst then
		worst = took
	end

	if not best then
		best = took
	end

	if worst < took then
		worst = took
		continue
	end

	if best > took then
		best = took
	end
end

local sum = 0
for _, v in times do
	sum += v
end

local avg = sum / #times

print("Testing successful")
print(`Average: {avg}s`)
print(`Best: {best}s`)
print(`Worst: {worst}s`)
