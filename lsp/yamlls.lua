-- yamlls: schema catalog from SchemaStore.nvim (which schema for which file:
-- GitHub workflows, docker-compose, gitlab-ci...); the schema itself is fetched
-- from schemastore.org on first use. Without the plugin, the server downloads
-- the catalog itself.
local ok, schemastore = pcall(require, "schemastore")

return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	root_markers = { ".git" },
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			format = { enable = false }, -- formatting via conform only
			schemaStore = ok and { enable = false, url = "" } or { enable = true },
			schemas = ok and schemastore.yaml.schemas() or {},
		},
	},
}
