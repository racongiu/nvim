-- YAML: yamlls validates (builtin schemastore catalog), yamlfmt formats.
-- yaml.ansible and yaml.docker-compose have their own filetypes (lang/ansible,
-- lang/docker) and never enter here.
return {
	lsp = { "yamlls" },
	tools = { "yaml-language-server", "yamlfmt" },
	formatters = { yaml = { "yamlfmt" } },
}
