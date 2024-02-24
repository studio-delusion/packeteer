local function average(nums: { number }): number
	local sum = 0

	for _, n in nums do
		sum += n
	end

	return sum / #nums
end

local function round_to(n: number, decimal_places: number): number
	return tonumber(string.format(`%.{decimal_places}f`, n)) :: number
end

type Unit = "second" | "milisecond" | "microsecond" | "nanosecond"
local units: { [Unit]: { multiplier: number, symbol: string } } = {
	second = {
		multiplier = 1,
		symbol = "s",
	},

	milisecond = {
		multiplier = 1_000,
		symbol = "ms",
	},

	microsecond = {
		multiplier = 1_000_000,
		symbol = "μs",
	},

	nanosecond = {
		multiplier = 1_000_000_000,
		symbol = "ns",
	},
}

local function benchmark<T...>(
	f: (T...) -> (),
	n: number,
	unit: Unit,
	decimal_places: number,
	...: T...
): (string, string, string)
	local times = {}
	local _best: number = nil
	local _worst: number = nil

	for _ = 1, n do
		local now = os.clock()

		f(...)

		local took = os.clock() - now
		table.insert(times, took)

		if not _worst then
			_worst = took
		end

		if not _best then
			_best = took
		end

		if _worst < took then
			_worst = took
		elseif _best > took then
			_best = took
		end
	end

	local _unit = units[unit]

	local avg = round_to(average(times) * _unit.multiplier, decimal_places) .. _unit.symbol
	local best = round_to(_best * _unit.multiplier, decimal_places) .. _unit.symbol
	local worst = round_to(_worst * _unit.multiplier, decimal_places) .. _unit.symbol

	return avg, best, worst
end

return benchmark
