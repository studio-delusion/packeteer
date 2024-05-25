--!native
--!optimize 2
type unit = "ns" | "micros" | "ms" | "s"
type bench_result = {
	min: number,
	max: number,
	avg: number,
}

local multiplier_map: { [unit]: number } = {
	ns = 1_000_000_000,
	micros = 1_000_000,
	ms = 1_000,
	s = 1,
}

local function benchmark<T...>(fn: (T...) -> (), unit: unit, tries: number, ...: T...): bench_result
	local times = {}

	for _ = 1, tries do
		local start = os.clock()
		fn(...)
		local finish = os.clock()

		table.insert(times, finish - start)
	end

	local min = 0
	local max = 0
	local sum = 0

	for _, time in times do
		sum += time

		if (time < min) or min == 0 then
			min = time
		end

		if time > max then
			max = time
		end
	end

	local avg = sum / #times

	local multiplier = multiplier_map[unit]

	return {
		min = min * multiplier,
		max = max * multiplier,
		avg = avg * multiplier,
	}
end

return benchmark
