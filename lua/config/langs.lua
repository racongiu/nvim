-- Central language toggle, consumed by utils/langs.lua.
-- false disables the whole stack of a plugins/lang/<name>.lua file
-- (LSP, mason tools, formatters, linters, setup hook); an absent
-- entry means enabled. Mason binaries are not uninstalled.
--
-- Les stacks retirées (ansible, css, docker, html, json, toml,
-- typescript, yaml) vivent dans _archive/ : voir _archive/README.md
-- pour les réactiver.
return {
	c = true,
	normc42 = true, -- not a fiche: flag read by lang/c.lua. true = 42 norm for C (c_formatter_42 + norminette, clangd without clang-tidy); false = clang-format
	lua = true,
	markdown = true,
	python = true,
}
