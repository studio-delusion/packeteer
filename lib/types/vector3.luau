local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local vector3: t.DataType<Vector3> = {
	read = function(buff: buffer, cursor: number): (Vector3, number)
		local x = buffer.readf32(buff, cursor)
		cursor += 4

		local y = buffer.readf32(buff, cursor)
		cursor += 4

		local z = buffer.readf32(buff, cursor)
		cursor += 4

		return Vector3.new(x, y, z), cursor
	end,

	write = function(value: Vector3)
		writer.alloc(12)
		writer.f32(value.X)
		writer.f32(value.Y)
		writer.f32(value.Z)
	end,
}

return vector3
