local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local i8: t.DataType<number> = {
	read = function(buff: buffer, cursor: number): (number, number)
		return buffer.readi8(buff, cursor), 1
	end,

	write = function(value: number)
		writer.alloc(1)
		writer.i8(value)
	end,
}

return i8
