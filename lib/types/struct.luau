local packeteer = script.Parent.Parent
local t = require(packeteer.t)

return function<T>(definition: t.StructDefinition): t.DataType<T>
	return {
		read = function(buff: buffer, cursor: number): (T, number)
			local constructed = {}
			local struct_cursor = cursor

			for key, data_type in definition do
				local value, length = data_type.read(buff, struct_cursor)

				constructed[key] = value

				struct_cursor += length
			end

			return constructed :: any, struct_cursor - cursor
		end,

		write = function(struct: T)
			for key, data_type in definition do
				data_type.write((struct :: any)[key])
			end
		end,
	}
end
