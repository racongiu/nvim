-- Aggregates the plugins/lang/*.lua data files for the engines
-- (plugins/lsp/lsp.lua, plugins/format.lua, plugins/lint.lua).
-- config/langs.lua is the on/off switchboard.
local M = {}

local toggles = require("config.langs")

function M.list()
	local langs = {}
	local dir = vim.fn.stdpath("config") .. "/lua/plugins/lang"
	for _, file in ipairs(vim.fn.globpath(dir, "*.lua", false, true)) do
		local name = vim.fn.fnamemodify(file, ":t:r")
		if toggles[name] ~= false then
			table.insert(langs, require("plugins.lang." .. name))
		end
	end
	return langs
end

return M
