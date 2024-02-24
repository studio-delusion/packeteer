export type WriterData = {
	size: number,
	cursor: number,
	buff: buffer,
}

export type DataType<T> = {
	read: (buff: buffer, cursor: number) -> (T, number),
	write: (value: T) -> (),
}

export type StructDefinition = { [string]: DataType<any> }

export type Packet<T> = {
	serialize: (data: T) -> buffer,
	deserialize: (buff: buffer) -> T,
}

export type Packeteer = {
	define: <T>(definition: T) -> Packet<T>,

	u8: number,
	i8: number,
	u16: number,
	i16: number,
	u32: number,
	i32: number,
	f32: number,
	f64: number,
	boolean: boolean,
	string: string,
	vector3: Vector3,

	optional: <T>(value: T) -> T?,
	array: <T>(value: T) -> { T },
	map: <K, V>(key: K, value: V) -> { [K]: V },
	struct: <T>(definition: T) -> T,
}

return "t"
