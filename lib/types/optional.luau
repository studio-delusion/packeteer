local packeteer = script.Parent.Parent
local t = require(packeteer.t)
local writer = require(packeteer.writer)

return function<T>(data_type: t.DataType<T>): t.DataType<T?>
	return {
		read = function(buff: buffer, cursor: number): (T?, number)
			local exists = buffer.readu8(buff, cursor)

			if exists == 0 then
				return nil, 1
			end

			local item, length = data_type.read(buff, cursor + 1)
			return item, length + 1
		end,

		write = function(value: T?)
			writer.alloc(1)
			if not value then
				writer.bfalse()
				return
			end

			writer.btrue()

			data_type.write(value)
		end,
	}
end
