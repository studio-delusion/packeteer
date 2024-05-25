--!nocheck
local process = require("@lune/process")

process.spawn("rojo", {
	"sourcemap",
	"default.project.json",
	"-o",
	"sourcemap.json",
})

process.spawn("curl", {
	"-O",
	"https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.luau",
})

process.spawn("luau-lsp", {
	"analyze",
	"--definitions=globalTypes.d.luau",
	"--base-luaurc=.luaurc",
	"--sourcemap=sourcemap.json",
	"--settings=.vscode/settings.json",
	"--no-strict-dm-types",
	"--ignore Packages/**/*.lua",
	"--ignore Packages/**/*.luau",
	"lib/",
})
