-- Linting engine. Linters come from the `linters`/`custom_linters` fields
-- of plugins/lang/*.lua; a value is a list or a function(bufnr).
local linters_by_ft = {}
for _, lang in ipairs(require("utils.langs").list()) do
	for ft, linters in pairs(lang.linters or {}) do
		linters_by_ft[ft] = linters
	end
	for name, def in pairs(lang.custom_linters or {}) do
		require("lint").linters[name] = def
	end
end

local function lint(buf)
	local linters = linters_by_ft[vim.bo[buf].filetype]
	if type(linters) == "function" then
		linters = linters(buf)
	end
	if linters and #linters > 0 then
		vim.b[buf].active_linter = table.concat(linters, ", ") -- read by the statusline
		require("lint").try_lint(linters, { ignore_errors = true }) -- missing binary or crash: no notification
	else
		vim.b[buf].active_linter = nil
	end
end

local group = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = group,
	callback = function(args)
		lint(args.buf)
	end,
})

-- Live linting while editing (insert mode included). Linters spawn an external
-- process, so TextChanged/TextChangedI fire on every keystroke: debounce to
-- lint only once typing pauses. Pairs with update_in_insert (lsp/lsp.lua) so
-- the diagnostics actually refresh on screen before InsertLeave.
local timer = assert(vim.uv.new_timer())
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
	group = group,
	callback = function(args)
		timer:stop()
		timer:start(
			300,
			0,
			vim.schedule_wrap(function()
				-- try_lint always lints the CURRENT buffer: skip if the user switched
				-- (the other buffer is re-linted on BufEnter)
				if args.buf == vim.api.nvim_get_current_buf() then
					lint(args.buf)
				end
			end)
		)
	end,
})

-- On-demand re-lint, emitted by plugins/format.lua once a manual format finishes
-- (the debounced TextChanged autocmd above also covers it, 300 ms later).
vim.api.nvim_create_autocmd("User", {
	pattern = "LintRefresh",
	group = group,
	callback = function()
		lint(vim.api.nvim_get_current_buf())
	end,
})
