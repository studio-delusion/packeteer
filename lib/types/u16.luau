local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local u16: t.DataType<number> = {
	read = function(buff: buffer, cursor: number): (number, number)
		return buffer.readu16(buff, cursor), 2
	end,

	write = function(value: number)
		writer.alloc(2)
		writer.u16(value)
	end,
}

return u16
