-- Formatting engine. Formatters come from the `formatters`/`custom_formatters`
-- fields of plugins/lang/*.lua. Rule: a formatter runs only when the project
-- configures it (require_cwd); the one fallback is C, which follows the 42 norm.
-- Fixers (a linter's --fix mode, defined as conform formatters) come from the
-- `fixers` (<leader>cx) and `save_fixers` (:w) fields, under the same rule.
local formatters_by_ft, custom_formatters, fixers, save_fixers = {}, {}, {}, {}
for _, lang in ipairs(require("utils.langs").list()) do
	for ft, formatters in pairs(lang.formatters or {}) do
		formatters_by_ft[ft] = formatters
	end
	for ft, names in pairs(lang.fixers or {}) do
		fixers[ft] = names
	end
	for ft, names in pairs(lang.save_fixers or {}) do
		save_fixers[ft] = names
	end
	for name, def in pairs(lang.custom_formatters or {}) do
		custom_formatters[name] = def
	end
end

local conform = require("conform")

-- The buffer's fixers that its project enables, then its formatters: fix first,
-- then format (lint follows via TextChanged, plugins/lint.lua)
local function fix_then_format(by_ft, bufnr)
	local names = vim.tbl_filter(function(name)
		return conform.get_formatter_info(name, bufnr).available
	end, by_ft[vim.bo[bufnr].filetype] or {})
	local fixed = #names > 0
	for _, f in ipairs(conform.list_formatters_to_run(bufnr)) do
		names[#names + 1] = f.name
	end
	return names, fixed
end

conform.setup({
	-- deliberate pin (= current default): formatting goes through conform
	-- only, never the LSP servers, even if conform's default ever changes
	default_format_opts = { lsp_format = "never" },
	format_on_save = function(bufnr)
		-- 2000: default 1000 is tight for python-based formatters' cold start
		return { timeout_ms = 2000, formatters = (fix_then_format(save_fixers, bufnr)) }
	end,
	notify_no_formatters = false, -- no project config = no formatting, silently
	formatters_by_ft = formatters_by_ft,
	formatters = custom_formatters,
})
-- gq goes through conform too (otherwise Neovim wires it to LSP formatting)
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
	-- no manual re-lint needed: the buffer change fires TextChanged (plugins/lint.lua)
	conform.format({ async = true })
end, { desc = "Format buffer/selection" })

vim.keymap.set("n", "<leader>cx", function()
	local names, fixed = fix_then_format(fixers, 0)
	if not fixed then
		return vim.notify("No fixer for this buffer", vim.log.levels.WARN)
	end
	conform.format({ formatters = names, async = true })
end, { desc = "Fix lint issues + format" })

-- Formatters of the current buffer, memoized for the statusline
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("statusline-formatters", { clear = true }),
	callback = function(args)
		local names = {}
		for _, f in ipairs(conform.list_formatters(args.buf)) do
			names[#names + 1] = f.name
		end
		vim.b[args.buf].active_formatters = table.concat(names, ", ")
	end,
})
