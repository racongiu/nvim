-- dockerls: completion/hover; best practices come from hadolint (nvim-lint)
return {
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = { "Dockerfile", ".git" },
}
