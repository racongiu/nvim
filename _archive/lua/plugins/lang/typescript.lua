-- JS/TS: prettier by default; project-configured tools win (see utils/project)
local project = require("utils.project")
local markers = require("utils.markers")
local util = require("conform.util")

local tools = project.resolve({
	formatters = {
		{ tools = { "biome-check" }, markers = markers.biome },
		{ tools = { "eslint_fix" }, markers = markers.eslint },
		{ tools = { "prettier" }, markers = markers.prettier },
	},
	linters = {
		{ tools = { "biomejs" }, markers = markers.biome },
		{ tools = { "eslint_d" }, markers = markers.eslint },
	},
	default_formatters = { "prettier" },
	default_linters = {}, -- eslint needs a project config
})

local formatters, linters = {}, {}
for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
	formatters[ft] = tools.format
	linters[ft] = tools.lint
end

return {
	lsp = { "vtsls" },
	tools = { "vtsls", "prettier", "eslint_d", "biome" },
	formatters = formatters,
	linters = linters,
	custom_formatters = {
		-- eslint --fix via eslint_d (project's node_modules first, PATH as fallback)
		eslint_fix = {
			command = util.from_node_modules("eslint_d"),
			args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
			cwd = util.root_file(markers.eslint),
			require_cwd = true,
		},
	},
}
