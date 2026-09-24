-- Formatting engine. Formatters come from the `formatters`/`custom_formatters`
-- fields of plugins/lang/*.lua. Rule: a formatter runs only when the project
-- configures it (require_cwd); the one fallback is C, which follows the 42 norm.
local formatters_by_ft, custom_formatters = {}, {}
for _, lang in ipairs(require("utils.langs").list()) do
	for ft, formatters in pairs(lang.formatters or {}) do
		formatters_by_ft[ft] = formatters
	end
	for name, def in pairs(lang.custom_formatters or {}) do
		custom_formatters[name] = def
	end
end

require("conform").setup({
	-- deliberate pin (= current default): formatting goes through conform
	-- only, never the LSP servers, even if conform's default ever changes
	default_format_opts = { lsp_format = "never" },
	format_on_save = { timeout_ms = 2000 }, -- default 1000 is tight for python-based formatters' cold start
	notify_no_formatters = false, -- no project config = no formatting, silently
	formatters_by_ft = formatters_by_ft,
	formatters = custom_formatters,
})
-- gq goes through conform too (otherwise Neovim wires it to LSP formatting)
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true }, function(err)
		-- re-lint right away (the debounced TextChanged autocmd in plugins/lint.lua
		-- would also re-lint, 300 ms later)
		if not err then
			vim.api.nvim_exec_autocmds("User", { pattern = "LintRefresh" })
		end
	end)
end, { desc = "Format buffer/selection" })

-- Formatters of the current buffer, memoized for the statusline
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	group = vim.api.nvim_create_augroup("statusline-formatters", { clear = true }),
	callback = function(args)
		local names = {}
		for _, f in ipairs(require("conform").list_formatters(args.buf)) do
			names[#names + 1] = f.name
		end
		vim.b[args.buf].active_formatters = table.concat(names, ", ")
	end,
})
