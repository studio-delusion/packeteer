--!native
--!optimize 2
local t = require(script.Parent.t)

local current: t.WriterData = nil

local size: number = nil
local cursor: number = nil
local buff: buffer = nil

local function alloc(bytes: number)
	if cursor + bytes < size then
		return
	end

	size += bytes
	local new_buffer = buffer.create(size)
	buffer.copy(new_buffer, 0, buff)

	buff = new_buffer
end

local writer = {}

writer.alloc = alloc

function writer.u8(value: number)
	buffer.writeu8(buff, cursor, value)
	cursor += 1
end

function writer.i8(value: number)
	buffer.writei8(buff, cursor, value)
	cursor += 1
end

function writer.u16(value: number)
	buffer.writeu16(buff, cursor, value)
	cursor += 2
end

function writer.i16(value: number)
	buffer.writei16(buff, cursor, value)
	cursor += 2
end

function writer.u32(value: number)
	buffer.writeu32(buff, cursor, value)
	cursor += 4
end

function writer.i32(value: number)
	buffer.writei32(buff, cursor, value)
	cursor += 4
end

function writer.f32(value: number)
	buffer.writef32(buff, cursor, value)
	cursor += 4
end

function writer.f64(value: number)
	buffer.writef64(buff, cursor, value)
	cursor += 8
end

function writer.string(value: string)
	buffer.writestring(buff, cursor, value)
	cursor += string.len(value)
end

function writer.btrue()
	buffer.writeu8(buff, cursor, 1)
	cursor += 1
end

function writer.bfalse()
	buffer.writeu8(buff, cursor, 0)
	cursor += 1
end

function writer.buffer(to_copy: buffer)
	buffer.copy(buff, cursor, to_copy, 0)
end

function writer.load(data: t.WriterData)
	if current == data then
		return
	end

	current = data
	size = data.size
	cursor = data.cursor
	buff = data.buff
end

function writer.export(): t.WriterData
	current.size = size
	current.cursor = cursor
	current.buff = buff

	return current
end

return writer
