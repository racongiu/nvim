-- JSON/JSONC: jsonls validates against SchemaStore's catalog (package.json,
-- tsconfig.json...); formatted only by the project's biome or prettier config
-- (utils/jstools.lua).
local js = require("utils.jstools")

return {
	lsp = { "jsonls" },
	tools = { "json-lsp", "prettier", "biome" },
	formatters = { json = js.formatters(), jsonc = js.formatters() },
	custom_formatters = js.custom_formatters,
}
