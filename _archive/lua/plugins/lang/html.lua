-- HTML: vscode html server; project-configured tools win (see utils/project).
-- eslint (@html-eslint / eslint-plugin-html) can LINT html but not format it:
-- formatting detection covers biome and prettier.
local project = require("utils.project")
local markers = require("utils.markers")

local tools = project.resolve({
	formatters = {
		{ tools = { "biome-check" }, markers = markers.biome },
		{ tools = { "prettier" }, markers = markers.prettier },
	},
	linters = {
		{ tools = { "eslint_d" }, markers = markers.eslint_html },
	},
	default_formatters = { "prettier" },
	default_linters = {},
})

return {
	lsp = { "html" },
	tools = { "html-lsp", "prettier" },
	formatters = { html = tools.format },
	linters = { html = tools.lint },
}
