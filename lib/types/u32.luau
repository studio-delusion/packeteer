local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local u32: t.DataType<number> = {
	read = function(buff: buffer, cursor: number): (number, number)
		return buffer.readu32(buff, cursor), 4
	end,

	write = function(value: number)
		writer.alloc(4)
		writer.u32(value)
	end,
}

return u32
