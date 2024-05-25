--!strict
--!native
--!optimize 2
local create_vector = if string.find(_VERSION, "Lune") then getfenv().vector else Vector3.new -- lune support

type channel = {
	buff: buffer,
	cursor: number,
	size: number,
}

local NEW_BUFFER_SIZE: number = 1024

local function create_channel(): channel
	return {
		buff = buffer.create(NEW_BUFFER_SIZE),
		cursor = 0,
		size = NEW_BUFFER_SIZE,
	}
end

local ref: channel = create_channel()
local ref_buff: buffer = ref.buff
local ref_cursor: number = ref.cursor
local ref_size: number = ref.size

local function load_channel(channel: channel)
	if ref == channel then
		return
	end

	ref = channel
	ref_buff = channel.buff
	ref_cursor = channel.cursor
	ref_size = channel.size
end

local function save_channel()
	ref.buff = ref_buff
	ref.cursor = ref_cursor
	ref.size = ref_size
end

local function dump_channel(channel: channel): buffer?
	local cursor = channel.cursor
	if cursor == 0 then
		return nil
	end

	local dump = buffer.create(cursor)

	buffer.copy(dump, 0, channel.buff, 0, cursor)

	channel.cursor = 0

	if channel == ref then
		ref_cursor = 0
	end

	return dump
end

local function alloc(bytes: number)
	if ref_cursor + bytes < ref_size then
		return
	end

	ref_size *= 2

	local new = buffer.create(ref_size)
	buffer.copy(new, 0, ref_buff)

	ref_buff = new
end

local function writeu8(value: number)
	buffer.writeu8(ref_buff, ref_cursor, value)
	ref_cursor += 1
end

local function readu8(): number
	ref_cursor += 1
	return buffer.readu8(ref_buff, ref_cursor - 1)
end

local function writei8(value: number)
	buffer.writei8(ref_buff, ref_cursor, value)
	ref_cursor += 1
end

local function readi8(): number
	ref_cursor += 1
	return buffer.readi8(ref_buff, ref_cursor - 1)
end

local function writeu16(value: number)
	buffer.writeu16(ref_buff, ref_cursor, value)
	ref_cursor += 2
end

local function readu16(): number
	ref_cursor += 2
	return buffer.readu16(ref_buff, ref_cursor - 2)
end

local function writei16(value: number)
	buffer.writei16(ref_buff, ref_cursor, value)
	ref_cursor += 2
end

local function readi16(): number
	ref_cursor += 2
	return buffer.readi16(ref_buff, ref_cursor - 2)
end

local function writeu32(value: number)
	buffer.writeu32(ref_buff, ref_cursor, value)
	ref_cursor += 4
end

local function readu32(): number
	ref_cursor += 4
	return buffer.readu32(ref_buff, ref_cursor - 4)
end

local function writei32(value: number)
	buffer.writei32(ref_buff, ref_cursor, value)
	ref_cursor += 4
end

local function readi32(): number
	ref_cursor += 4
	return buffer.readi32(ref_buff, ref_cursor - 4)
end

local function writef32(value: number)
	buffer.writef32(ref_buff, ref_cursor, value)
	ref_cursor += 4
end

local function readf32(): number
	ref_cursor += 4
	return buffer.readf32(ref_buff, ref_cursor - 4)
end

local function writef64(value: number)
	buffer.writef64(ref_buff, ref_cursor, value)
	ref_cursor += 8
end

local function readf64(): number
	ref_cursor += 8
	return buffer.readf64(ref_buff, ref_cursor - 8)
end

local function writebool(value: boolean)
	buffer.writeu8(ref_buff, ref_cursor, if value then 1 else 0)
	ref_cursor += 1
end

local function readbool(): boolean
	ref_cursor += 1
	return buffer.readu8(ref_buff, ref_cursor - 1) == 1
end

local function writestring(value: string, length: number)
	buffer.writestring(ref_buff, ref_cursor, value)
	ref_cursor += length
end

local function readstring(length: number): string
	ref_cursor += length
	return buffer.readstring(ref_buff, ref_cursor - length, length)
end

type data_type<T> = {
	write: (value: T) -> (),
	read: () -> T,
}

local u8_serdes: data_type<number> = {
	write = function(value: number)
		alloc(1)
		writeu8(value)
	end,
	read = readu8,
}

local i8_serdes: data_type<number> = {
	write = function(value: number)
		alloc(1)
		writei8(value)
	end,
	read = readi8,
}

local u16_serdes: data_type<number> = {
	write = function(value: number)
		alloc(2)
		writeu16(value)
	end,
	read = readu16,
}

local i16_serdes: data_type<number> = {
	write = function(value: number)
		alloc(2)
		writei16(value)
	end,
	read = readi16,
}

local u32_serdes: data_type<number> = {
	write = function(value: number)
		alloc(4)
		writeu32(value)
	end,
	read = readu32,
}

local i32_serdes: data_type<number> = {
	write = function(value: number)
		alloc(4)
		writei32(value)
	end,
	read = readi32,
}

local f32_serdes: data_type<number> = {
	write = function(value: number)
		alloc(4)
		writef32(value)
	end,
	read = readf32,
}

local f64_serdes: data_type<number> = {
	write = function(value: number)
		alloc(8)
		writef64(value)
	end,
	read = readf64,
}

local boolean_serdes: data_type<boolean> = {
	write = function(value: boolean)
		alloc(1)
		writebool(value)
	end,
	read = readbool,
}

local vector3_serdes: data_type<Vector3> = {
	write = function(value: Vector3)
		alloc(12)
		writef32(value.X)
		writef32(value.Y)
		writef32(value.Z)
	end,
	read = function(): Vector3
		return create_vector(readf32(), readf32(), readf32())
	end,
}

local nothing_serdes: data_type<nil> = {
	write = function() end,
	read = function() end,
}

local function string_serdes(length: number?): data_type<string>
	if length then
		return {
			write = function(value: string)
				alloc(length)
				writestring(value, length)
			end,
			read = function(): string
				return readstring(length)
			end,
		}
	end

	return {
		write = function(value: string)
			local length = string.len(value)
			alloc(length + 2)
			writeu16(length)
			writestring(value, length)
		end,
		read = function(): string
			local length = readu16()
			return readstring(length)
		end,
	}
end

local function buffer_serdes(length: number?): data_type<buffer>
	if length then
		return {
			write = function(value: buffer)
				alloc(length)
				buffer.copy(ref_buff, ref_cursor, value)
				ref_cursor += length
			end,
			read = function(): buffer
				local dump = buffer.create(length)
				buffer.copy(dump, 0, ref_buff, ref_cursor, length)
				return dump
			end,
		}
	end

	return {
		write = function(value: buffer)
			local length = buffer.len(value)
			alloc(length + 2)
			writeu16(length)
			buffer.copy(ref_buff, ref_cursor, value)
			ref_cursor += length
		end,
		read = function(): buffer
			local length = readu16()
			local dump = buffer.create(length)
			buffer.copy(dump, 0, ref_buff, ref_cursor, length)
			return dump
		end,
	}
end

local function optional_serdes<T>(data_type: data_type<T>): data_type<T?>
	local read = data_type.read
	local write = data_type.write

	return {
		write = function(value: T?)
			local exists = value ~= nil
			writebool(exists)

			if exists then
				write(value :: T)
			end
		end,
		read = function(): T?
			if not readbool() then
				return nil
			end

			return read()
		end,
	}
end

local function array_serdes<T>(data_type: data_type<T>, length: number?): data_type<{ [number]: T }>
	local read = data_type.read
	local write = data_type.write

	if length then
		return {
			write = function(value: { T })
				for i = 1, length do
					write(value[i])
				end
			end,
			read = function(): { T }
				local array = table.create(length)

				for i = 1, length do
					array[i] = read()
				end

				return array
			end,
		}
	end

	return {
		write = function(value: { T })
			local length = #value
			writeu16(length)

			for i = 1, length do
				write(value[i])
			end
		end,
		read = function(): { T }
			local length = readu16()
			local array = table.create(length)

			for i = 1, length do
				array[i] = read()
			end

			return array
		end,
	}
end

local function map_serdes<K, V>(key: data_type<K>, value: data_type<V>, length: number?): data_type<{ [K]: V }>
	local read_key = key.read
	local write_key = key.write

	local read_value = value.read
	local write_value = value.write

	if length then
		return {
			write = function(value: { [K]: V })
				for key, value in value do
					write_key(key)
					write_value(value)
				end
			end,
			read = function(): { [K]: V }
				local map = {}

				for _ = 1, length do
					local key = read_key()
					local value = read_value()

					map[key] = value
				end

				return map
			end,
		}
	end

	return {
		write = function(value: { [K]: V })
			local length = 0
			for _ in value do
				length += 1
			end

			writeu16(length)

			for key, value in value do
				write_key(key)
				write_value(value)
			end
		end,
		read = function(): { [K]: V }
			local length = readu16()
			local map = {}

			for _ = 1, length do
				local key = read_key()
				local value = read_value()

				map[key] = value
			end

			return map
		end,
	}
end

local function struct_serdes<T>(definition: { [string]: data_type<any> }): data_type<T>
	return {
		write = function(value: T)
			for key, data_type in definition do
				data_type.write((value :: any)[key])
			end
		end,
		read = function(): T
			local struct = {}

			for key, data_type in definition do
				local value = data_type.read()
				struct[key] = value
			end

			return struct :: any
		end,
	}
end

local function define(definition)
	local serdes = struct_serdes(definition)
	local read = serdes.read
	local write = serdes.write

	local packet = {}

	function packet.serialize(value): buffer
		local channel = create_channel()
		load_channel(channel)

		write(value)
		save_channel()

		local dump = dump_channel(channel) :: any
		return dump
	end

	function packet.deserialize(buff: buffer)
		local channel = {
			buff = buff,
			cursor = 0,
			size = buffer.len(buff),
		}
		load_channel(channel)

		return read()
	end

	return packet
end

export type packet<T> = {
	serialize: (data: T) -> buffer,
	deserialize: (buff: buffer) -> T,
}

export type packeteer = {
	define: <T>(definition: T) -> packet<T>,

	u8: number,
	i8: number,
	u16: number,
	i16: number,
	u32: number,
	i32: number,
	f32: number,
	f64: number,
	boolean: boolean,
	vector3: Vector3,
	nothing: nil,

	buffer: (length: number?) -> buffer,
	string: (length: number?) -> string,

	optional: <T>(data_type: T) -> T?,
	array: <T>(data_type: T) -> { T },
	map: <K, V>(key_type: K, value_type: V) -> { [K]: V },
	struct: <T>(definition: T) -> T,
}

return (
	table.freeze({
		define = define,

		u8 = u8_serdes,
		i8 = i8_serdes,
		u16 = u16_serdes,
		i16 = i16_serdes,
		u32 = u32_serdes,
		i32 = i32_serdes,
		f32 = f32_serdes,
		f64 = f64_serdes,
		boolean = boolean_serdes,
		vector3 = vector3_serdes,
		nothing = nothing_serdes,

		buffer = buffer_serdes,
		string = string_serdes,

		optional = optional_serdes,
		array = array_serdes,
		map = map_serdes,
		struct = struct_serdes,
	}) :: any
) :: packeteer
