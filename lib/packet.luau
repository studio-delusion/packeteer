--!native
--!optimize 2
local packeteer = script.Parent
local writer = require(packeteer.writer)
local struct = require(packeteer.types.struct)

return function(definition)
	local serdes = struct(definition)
	local packet = {}

	function packet.serialize(value): buffer
		writer.load({
			buff = buffer.create(0),
			size = 0,
			cursor = 0,
		})

		serdes.write(value)

		local export = writer.export()
		return export.buff
	end

	function packet.deserialize(buff: buffer)
		return serdes.read(buff, 0)
	end

	return packet
end
