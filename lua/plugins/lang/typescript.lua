-- JS/TS: vtsls + tools enabled ONLY by the project's config (utils/jstools.lua).
--   biome config (biome.json[c])     -> biome (format + lint + fix)
--   prettier config (.prettierrc*, prettier.config.*, "prettier" in package.json)
--                                    -> prettier (format)
--   eslint config (eslint.config.*, .eslintrc*, "eslintConfig" in package.json)
--                                    -> eslint via eslint_d (lint + fix)
--   none of these                    -> no formatting, no linting (LSP only)
-- prettier and eslint may run together; a biome config replaces both.
local js = require("utils.jstools")

local formatters, linters, fixers, save_fixers = {}, {}, {}, {}
for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
	formatters[ft] = js.formatters()
	linters[ft] = js.linters
	fixers[ft] = { "biome-check", "eslint_d" } -- <leader>cx
	save_fixers[ft] = { "eslint_d" } -- :w (biome: format only on save)
end

return {
	lsp = { "vtsls" },
	tools = { "vtsls", "eslint_d", "prettier", "biome" }, -- fallbacks: the project's own come first
	formatters = formatters,
	linters = linters,
	fixers = fixers,
	save_fixers = save_fixers,
	custom_formatters = js.custom_formatters,
	custom_linters = js.custom_linters,
}
