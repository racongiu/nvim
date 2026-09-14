-- JSON/JSONC: jsonls + SchemaStore for validation, prettier for formatting
return {
	lsp = { "jsonls" },
	tools = { "json-lsp", "prettier" },
	formatters = { json = { "prettier" }, jsonc = { "prettier" } },
}
