local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local buff: t.DataType<buffer> = {
	read = function(buff: buffer, cursor: number): (buffer, number)
		local buff_length = buffer.readu16(buff, cursor)
		local constructed = buffer.create(buff_length)

		buffer.copy(constructed, 0, buff, cursor + 2, buff_length)

		return constructed, buff_length
	end,

	write = function(value: buffer)
		local length = buffer.len(value)

		writer.alloc(2 + length)
		writer.u16(length)
		writer.buffer(value)
	end,
}

return buff
