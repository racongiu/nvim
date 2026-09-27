-- jsonls has no builtin schema catalog: SchemaStore.nvim provides it
-- (pcall: without the plugin, jsonls still runs, with no schema validation)
local ok, schemastore = pcall(require, "schemastore")

return {
	cmd = { "vscode-json-language-server", "--stdio" },
	filetypes = { "json", "jsonc" },
	root_markers = { ".git" },
	settings = {
		json = {
			schemas = ok and schemastore.json.schemas() or {},
			validate = { enable = true },
		},
	},
}
