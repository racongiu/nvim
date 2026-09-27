-- CSS/SCSS/LESS: cssls (completion, validation) + tools enabled ONLY by the
-- project's config (utils/jstools.lua).
--   biome config (css only)                   -> biome (format + lint + fix)
--   prettier config                           -> prettier (format)
--   stylelint config (.stylelintrc*, stylelint.config.*, "stylelint" in package.json)
--                                             -> stylelint (lint + fix)
--   none of these                             -> no formatting, no linting (LSP only)
-- biome does not support scss/less: they always use prettier/stylelint.
local js = require("utils.jstools")

local formatters, linters, fixers = {}, {}, {}
for _, ft in ipairs({ "css", "scss", "less" }) do
	formatters[ft] = js.formatters()
	linters[ft] = js.css_linters
	fixers[ft] = { "biome-check", "stylelint" } -- <leader>cx only (stylelint --fix can rewrite rules)
end

return {
	lsp = { "cssls" },
	tools = { "css-lsp", "stylelint", "prettier", "biome" }, -- fallbacks: the project's own come first
	formatters = formatters,
	linters = linters,
	fixers = fixers,
	custom_formatters = js.custom_formatters,
	custom_linters = js.custom_linters,
}
