-- Shell (sh/bash): bashls LSP, which runs shellcheck (always on, like LSP
-- diagnostics). shfmt formats only when the project has an .editorconfig
-- (shfmt reads its settings there). zsh: tree-sitter only, no tool supports it.
return {
	lsp = { "bashls" },
	tools = { "bash-language-server", "shellcheck", "shfmt" },
	formatters = { sh = { "shfmt" }, bash = { "shfmt" } },
	custom_formatters = {
		shfmt = {
			cwd = function(_, ctx)
				return vim.fs.root(ctx.buf, ".editorconfig")
			end,
			require_cwd = true,
		},
	},
}
