local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local f64: t.DataType<number> = {
	read = function(buff: buffer, cursor: number): (number, number)
		return buffer.readf64(buff, cursor), 8
	end,

	write = function(value: number)
		writer.alloc(8)
		writer.f64(value)
	end,
}

return f64
