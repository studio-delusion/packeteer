local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local i32: t.DataType<number> = {
	read = function(buff: buffer, cursor: number): (number, number)
		return buffer.readi32(buff, cursor), 4
	end,

	write = function(value: number)
		writer.alloc(4)
		writer.i32(value)
	end,
}

return i32
