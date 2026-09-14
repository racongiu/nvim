-- Docker: dockerls + hadolint for Dockerfiles, compose-language-service for compose
return {
	lsp = { "dockerls", "docker_compose_language_service" },
	tools = { "dockerfile-language-server", "docker-compose-language-service", "hadolint", "yamlfmt" },
	linters = { dockerfile = { "hadolint" } },
	-- pinned: compose files never follow a project formatter detection
	formatters = { ["yaml.docker-compose"] = { "yamlfmt" } },
	-- Neovim does not detect the compose filetype natively
	setup = function()
		vim.filetype.add({
			filename = {
				["docker-compose.yml"] = "yaml.docker-compose",
				["docker-compose.yaml"] = "yaml.docker-compose",
				["compose.yml"] = "yaml.docker-compose",
				["compose.yaml"] = "yaml.docker-compose",
			},
			pattern = {
				["docker%-compose%..*%.ya?ml"] = "yaml.docker-compose", -- docker-compose.override.yml, etc.
			},
		})
	end,
}
