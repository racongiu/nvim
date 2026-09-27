return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = { "package.json", ".git" },
	init_options = {
		provideFormatter = false, -- prettier via conform
		embeddedLanguages = { css = true, javascript = true },
	},
}
