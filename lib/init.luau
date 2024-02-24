local t = require(script.t)
export type WriterData = t.WriterData
export type DataType<T> = t.DataType<T>
export type StructDefinition = t.StructDefinition
export type Packet<T> = t.Packet<T>

local data_types = script.types
local u8 = require(data_types.u8)
local i8 = require(data_types.i8)
local u16 = require(data_types.u16)
local i16 = require(data_types.i16)
local u32 = require(data_types.u32)
local i32 = require(data_types.i32)
local f32 = require(data_types.f32)
local f64 = require(data_types.f64)
local boolean = require(data_types.boolean)
local str = require(data_types.string)
local map = require(data_types.map)
local array = require(data_types.array)
local struct = require(data_types.struct)
local optional = require(data_types.optional)
local vector3 = require(data_types.vector3)

local packet = require(script.packet)

return (
	table.freeze({
		define = packet,

		u8 = u8,
		i8 = i8,
		u16 = u16,
		i16 = i16,
		u32 = u32,
		i32 = i32,
		f32 = f32,
		f64 = f64,
		boolean = boolean,
		string = str,
		vector3 = vector3,

		optional = optional,
		array = array,
		map = map,
		struct = struct,
	}) :: any
) :: t.Packeteer
