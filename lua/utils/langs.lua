-- Aggregates the plugins/lang/*.lua files. config/langs.lua is the on/off
-- switchboard. Fields of a lang file (all optional):
--   lsp, tools, formatters, linters, custom_*, fixers, save_fixers
--       data read by the engines (plugins/lsp/lsp.lua, format.lua, lint.lua)
--   plugins  vim.pack specs of plugins used only by this language
--   setup    function configuring those plugins (run once, after plugins/)
-- A disabled language installs, loads and configures nothing.
local M = {}

local toggles = require("config.langs")

-- { name, spec } for every enabled language, alphabetical order
local function enabled()
	local langs = {}
	local dir = vim.fn.stdpath("config") .. "/lua/plugins/lang"
	for _, file in ipairs(vim.fn.globpath(dir, "*.lua", false, true)) do
		local name = vim.fn.fnamemodify(file, ":t:r")
		if toggles[name] ~= false then
			table.insert(langs, { name = name, spec = require("plugins.lang." .. name) })
		end
	end
	return langs
end

function M.list()
	return vim.tbl_map(function(lang)
		return lang.spec
	end, enabled())
end

-- vim.pack specs of the enabled languages' plugins
function M.plugins()
	local specs = {}
	for _, lang in ipairs(enabled()) do
		vim.list_extend(specs, lang.spec.plugins or {})
	end
	return specs
end

-- Run each enabled language's setup; a failing one is reported, the others still run
function M.setup()
	for _, lang in ipairs(enabled()) do
		if lang.spec.setup then
			local ok, err = pcall(lang.spec.setup)
			if not ok then
				vim.schedule(function()
					vim.notify(("lang/%s: setup failed\n%s"):format(lang.name, err), vim.log.levels.ERROR)
				end)
			end
		end
	end
end

return M
