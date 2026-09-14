-- yamlls: validation via the server's BUILTIN schemastore.org catalog, picked
-- by path (SchemaStore.nvim only serves jsonls). CI files (gitlab-ci, github
-- workflows) are plain yaml in neovim and covered by the catalog's path
-- matching. yaml.ansible and yaml.docker-compose have dedicated servers;
-- helm would need helm_ls.
return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	root_markers = { ".git" },
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			format = { enable = false }, -- yamlfmt via conform
			schemaStore = { enable = true },
			schemas = {
				-- Kubernetes manifests by path convention (CRDs need
				-- per-project schemas or modelines)
				kubernetes = { "k8s/**", "kubernetes/**", "manifests/**", "*.k8s.yaml" },
			},
		},
	},
}
