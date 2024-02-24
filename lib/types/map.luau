local packeteer = script.Parent.Parent
local writer = require(packeteer.writer)
local t = require(packeteer.t)

return function<K, V>(key_type: t.DataType<K>, value_type: t.DataType<V>): t.DataType<{ [K]: V }>
	return {
		read = function(buff: buffer, cursor: number): ({ [K]: V }, number)
			local map_length = buffer.readu16(buff, cursor)
			local map_cursor = cursor + 2
			local constructed = {}

			for _ = 1, map_length do
				local key, key_length = key_type.read(buff, map_cursor)
				map_cursor += key_length

				local value, value_length = value_type.read(buff, map_cursor)
				map_cursor += value_length

				constructed[key] = value
			end

			return constructed, map_cursor - cursor
		end,

		write = function(value: { [K]: V })
			local length = 0
			for _ in value do
				length += 1
			end

			writer.alloc(2)
			writer.u16(length)

			for key, value in value do
				key_type.write(key)
				value_type.write(value)
			end
		end,
	}
end
