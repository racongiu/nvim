-- TOML: taplo LSP (schema validation: pyproject.toml, Cargo.toml...);
-- taplo formats only when the project has a taplo.toml / .taplo.toml.
local markers = { "taplo.toml", ".taplo.toml" }

return {
	lsp = { "taplo" },
	tools = { "taplo" },
	formatters = { toml = { "taplo" } },
	custom_formatters = {
		taplo = {
			cwd = function(_, ctx)
				return vim.fs.root(ctx.buf, markers)
			end,
			require_cwd = true,
		},
	},
}
