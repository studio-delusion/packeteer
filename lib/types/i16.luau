local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local i16: t.DataType<number> = {
	read = function(buff: buffer, cursor: number): (number, number)
		return buffer.readi16(buff, cursor), 2
	end,

	write = function(value: number)
		writer.alloc(2)
		writer.i16(value)
	end,
}

return i16
