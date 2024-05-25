--!native
--!optimize 2
local packet = require("./packet")

local generate_fuzz = packet.fuzz
local serialize = packet.packet.serialize
local deserialize = packet.packet.deserialize

local fuzz = generate_fuzz()

local ser = serialize(fuzz)
local des = deserialize(ser)

assert(des.u8 == fuzz.u8, "des.u8 != u8")
assert(des.i8 == fuzz.i8, "des.i8 != i8")
assert(des.u16 == fuzz.u16, "des.u16 != u16")
assert(des.i16 == fuzz.i16, "des.i16 != i16")
assert(des.u32 == fuzz.u32, "des.u32 != u32")
assert(des.i32 == fuzz.i32, "des.i32 != i32")
assert(des.f32 == fuzz.f32, "des.f32 != f32")
assert(des.f64 == fuzz.f64, "des.f64 != f64")
assert(des.boolean == fuzz.boolean, "des.boolean != bool")
assert(des.vector3 == fuzz.vector3, "des.vector3 != vec3")
assert(des.nothing == fuzz.nothing, "des.nothing != nothing")

assert(des.string == fuzz.string, "des.string != str")

assert(des.optional == fuzz.optional, "des.optional != optional")

for k, v in des.array do
	assert(v == fuzz.array[k], "des.array != array")
end

for k, v in des.map do
	assert(v == fuzz.map[k], "des.map != map")
end

assert(des.struct.a == fuzz.struct.a, "des.struct.a != struct.a")
assert(des.struct.b == fuzz.struct.b, "des.struct.b != struct.b")

print("Fuzz testing successful")
