-- bash-language-server: completion, hover, definitions for sh/bash (not zsh).
-- Runs shellcheck itself (diagnostics always on) when the binary is found.
-- Formatting goes through conform (shfmt), never through the LSP.
return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
	root_markers = { ".git" },
	settings = {
		bashIde = {
			shfmt = { path = "" }, -- disable LSP formatting
		},
	},
}
