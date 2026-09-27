-- YAML: yamlls (SchemaStore catalog: CI workflows, docker-compose...) + tools
-- enabled ONLY by the project's config.
--   yamlfmt config (.yamlfmt, yamlfmt.y[a]ml...) -> yamlfmt (format)
--   else prettier config (utils/jstools.lua)    -> prettier (format)
--   yamllint config (.yamllint[.y[a]ml])         -> yamllint (lint)
-- Each runs from the root of the config that enabled it.
local js = require("utils.jstools")

local yamlfmt_markers = { ".yamlfmt", ".yamlfmt.yaml", ".yamlfmt.yml", "yamlfmt.yaml", "yamlfmt.yml" }
local yamllint_markers = { ".yamllint", ".yamllint.yaml", ".yamllint.yml" }

return {
	lsp = { "yamlls" },
	tools = { "yaml-language-server", "yamlfmt", "yamllint", "prettier" },
	formatters = { yaml = { "yamlfmt", "prettier", stop_after_first = true } },
	custom_formatters = {
		yamlfmt = {
			cwd = function(_, ctx)
				return vim.fs.root(ctx.buf, yamlfmt_markers)
			end,
			require_cwd = true,
		},
		prettier = js.custom_formatters.prettier,
	},
	linters = {
		yaml = function(bufnr)
			return vim.fs.root(bufnr, yamllint_markers) and { "yamllint" } or {}
		end,
	},
	custom_linters = {
		yamllint = function() -- nvim-lint's definition, run from the config's root
			local def = vim.deepcopy(require("lint.linters.yamllint"))
			def.cwd = vim.fs.root(0, yamllint_markers)
			return def
		end,
	},
}
