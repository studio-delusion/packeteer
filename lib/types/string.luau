local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local str: t.DataType<string> = {
	read = function(buff: buffer, cursor: number): (string, number)
		local length = buffer.readu16(buff, cursor)

		return buffer.readstring(buff, cursor + 2, length), length + 2
	end,

	write = function(value: string)
		local length = string.len(value)
		writer.alloc(length + 2)

		writer.u16(length)
		writer.string(value)
	end,
}

return str
