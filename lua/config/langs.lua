-- Central language toggle, consumed by utils/langs.lua.
-- false disables the whole stack of a plugins/lang/<name>.lua file
-- (LSP, mason tools, formatters, linters); an absent
-- entry means enabled. Mason binaries are not uninstalled.
--
-- Removed stacks (ansible, docker) live in _archive/:
-- see _archive/README.md to re-enable them.
return {
	c = true,
	css = true,
	html = true,
	json = true,
	lua = true,
	markdown = true,
	python = true,
	shell = true,
	toml = true,
	typescript = true,
	yaml = true,
}
