--!native
--!optimize 2
local benchmark = require("./benchmark")
local packet = require("./packet")

local generate_fuzz = packet.fuzz
local serialize = packet.packet.serialize
local deserialize = packet.packet.deserialize

local function serdes_bench()
	local fuzz = generate_fuzz()

	local ser = serialize(fuzz)
	local des = deserialize(ser)
end

local result = benchmark(serdes_bench, "s", 1_000)

print("Serdes benchmarking successful")
print(`Average: {result.avg}s`)
print(`Best: {result.min}s`)
print(`Worst: {result.max}s`)
