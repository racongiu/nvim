-- CSS/SCSS/LESS: cssls validates; project-configured tools win (see utils/project).
-- eslint (@eslint/css) and biome can LINT css but do not format it:
-- formatting detection covers biome, stylelint and prettier.
local project = require("utils.project")
local markers = require("utils.markers")

local tools = project.resolve({
	formatters = {
		{ tools = { "biome-check" }, markers = markers.biome },
		{ tools = { "stylelint" }, markers = markers.stylelint }, -- stylelint --fix
		{ tools = { "prettier" }, markers = markers.prettier },
	},
	linters = {
		{ tools = { "biomejs" }, markers = markers.biome },
		{ tools = { "eslint_d" }, markers = markers.eslint_css },
		{ tools = { "stylelint" }, markers = markers.stylelint },
	},
	default_formatters = { "prettier" },
	default_linters = {},
})

local formatters, linters = {}, {}
for _, ft in ipairs({ "css", "scss", "less" }) do
	formatters[ft] = tools.format
	linters[ft] = tools.lint
end

return {
	lsp = { "cssls" },
	tools = { "css-lsp", "stylelint", "prettier" },
	formatters = formatters,
	linters = linters,
}
