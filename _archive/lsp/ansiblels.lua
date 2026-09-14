-- ansiblels: runs ansible-lint itself (no nvim-lint wiring). Binaries
-- (python, ansible, ansible-lint) resolve through PATH: project first,
-- mason as fallback.
return {
	cmd = { "ansible-language-server", "--stdio" },
	filetypes = { "yaml.ansible" },
	root_markers = { "ansible.cfg", ".ansible-lint", ".git" },
	settings = {
		ansible = {
			python = { interpreterPath = "python" },
			ansible = { path = "ansible" },
			executionEnvironment = { enabled = false },
			validation = {
				enabled = true,
				lint = { enabled = true, path = "ansible-lint" },
			},
		},
	},
}
