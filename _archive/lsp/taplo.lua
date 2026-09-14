-- taplo: schemastore-based completion/validation; formatting via conform
return {
	cmd = { "taplo", "lsp", "stdio" },
	filetypes = { "toml" },
	root_markers = { "taplo.toml", ".taplo.toml", ".git" },
}
