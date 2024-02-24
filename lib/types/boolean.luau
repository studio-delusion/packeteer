local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

local boolean: t.DataType<boolean> = {
	read = function(buff: buffer, cursor: number): (boolean, number)
		return buffer.readu8(buff, cursor) == 1, 1
	end,

	write = function(value: boolean)
		writer.alloc(1)
		if value then
			writer.btrue()
			return
		end
		writer.bfalse()
	end,
}

return boolean
