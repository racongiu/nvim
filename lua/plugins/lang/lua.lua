-- Lua: lua_ls + stylua (only when the project has a .stylua.toml / stylua.toml)
return {
	lsp = { "lua_ls" },
	tools = { "lua-language-server", "stylua" },
	formatters = { lua = { "stylua" } },
	custom_formatters = { stylua = { require_cwd = true } },
}
