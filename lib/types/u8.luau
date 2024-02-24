local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local u8: t.DataType<number> = {
	read = function(buff: buffer, cursor: number): (number, number)
		return buffer.readu8(buff, cursor), 1
	end,

	write = function(value: number)
		writer.alloc(1)
		writer.u8(value)
	end,
}

return u8
