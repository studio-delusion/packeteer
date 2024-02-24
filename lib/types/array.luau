local packeteer = script.Parent.Parent
local writer = require(packeteer.writer)
local t = require(packeteer.t)

return function<T>(data_type: t.DataType<T>): t.DataType<{ T }>
	return {
		read = function(buff: buffer, cursor: number): ({ T }, number)
			local array_length = buffer.readu16(buff, cursor)
			local array_cursor = cursor + 2
			local constructed = {}

			for _ = 1, array_length do
				local item, length = data_type.read(buff, array_cursor)
				table.insert(constructed, item)

				array_cursor += length
			end

			return constructed, array_cursor - cursor
		end,

		write = function(value: { T })
			writer.alloc(2)
			writer.u16(#value)

			for _, item in value do
				data_type.write(item)
			end
		end,
	}
end
