-- HTML: html LSP (tags, attributes, embedded css/js) + tools enabled ONLY by
-- the project's config (utils/jstools.lua).
--   biome config with html enabled -> biome (format + lint)
--   prettier config                -> prettier (format)
--   none of these                  -> no formatting, no linting (LSP only)
local js = require("utils.jstools")

return {
	lsp = { "html" },
	tools = { "html-lsp", "prettier", "biome" }, -- fallbacks: the project's own come first
	formatters = { html = js.formatters() },
	linters = { html = js.html_linters },
	custom_formatters = js.custom_formatters,
	custom_linters = js.custom_linters,
}
