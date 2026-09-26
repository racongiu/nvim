-- Central language toggle, consumed by utils/langs.lua.
-- false disables the whole stack of a plugins/lang/<name>.lua file
-- (LSP, mason tools, formatters, linters); an absent
-- entry means enabled. Mason binaries are not uninstalled.
--
-- Removed stacks (ansible, css, docker, html, json, toml, typescript,
-- yaml) live in _archive/: see _archive/README.md to re-enable them.
return {
	c = true,
	lua = true,
	markdown = true,
	python = true,
}
