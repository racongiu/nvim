-- Project config-file markers, shared by the plugins/lang/*.lua fiches
-- (see utils/project.lua for the marker format).
local M = {}

M.biome = { "biome.json", "biome.jsonc" }

M.eslint = {
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	"eslint.config.ts",
	"eslint.config.mts",
	"eslint.config.cts",
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.json",
	".eslintrc.yml",
	".eslintrc.yaml",
}

M.prettier = {
	".prettierrc",
	".prettierrc.json",
	".prettierrc.yml",
	".prettierrc.yaml",
	".prettierrc.json5",
	".prettierrc.js",
	".prettierrc.cjs",
	".prettierrc.mjs",
	".prettierrc.toml",
	"prettier.config.js",
	"prettier.config.cjs",
	"prettier.config.mjs",
	{ "package.json", has = '"prettier"' },
}

-- eslint lints css/html only through dedicated plugins: gate on their
-- presence in package.json, not on a generic eslint config
M.eslint_css = { { "package.json", has = '"@eslint/css"' } }
M.eslint_html = { { "package.json", has = '"@html-eslint' }, { "package.json", has = '"eslint-plugin-html"' } }

M.stylelint = {
	".stylelintrc",
	".stylelintrc.json",
	".stylelintrc.yml",
	".stylelintrc.yaml",
	".stylelintrc.js",
	".stylelintrc.cjs",
	".stylelintrc.mjs",
	"stylelint.config.js",
	"stylelint.config.cjs",
	"stylelint.config.mjs",
	{ "package.json", has = '"stylelint"' },
}

return M
