--!nocheck
-- Passes the library through analyzing, styling & linting
local process = require("@lune/process")

local function spawn(cmd: string)
	local arguments = string.split(cmd, " ")
	local command = arguments[1]
	table.remove(arguments, 1)

	process.spawn(command, arguments, {
		stdio = "forward",
	})
end

spawn("lune run scripts/analyze.luau")

spawn("stylua lib/")

spawn("selene lib/")
