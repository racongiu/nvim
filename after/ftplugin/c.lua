-- Vertical bar at column 81, shown only while a line of the buffer goes past
-- 80 columns (tabs counted with 'tabstop').
-- Guard: ftplugin/cpp sources ftplugin/c.lua too, keep the bar for C only.
if vim.bo.filetype ~= "c" then
	return
end

local buf = vim.api.nvim_get_current_buf()
local group = vim.api.nvim_create_augroup("c-colorcolumn", { clear = false })

local function update()
	local too_long = vim.fn.search([[\%>80v.]], "nw") > 0
	vim.opt_local.colorcolumn = too_long and "81" or ""
end

vim.api.nvim_clear_autocmds({ group = group, buffer = buf })
vim.api.nvim_create_autocmd({ "BufWinEnter", "TextChanged", "TextChangedI" }, {
	group = group,
	buffer = buf,
	callback = update,
})
update()
