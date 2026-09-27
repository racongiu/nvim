-- Vertical bar right after a line-length limit, shown only while a line of the
-- buffer goes past it (tabs counted with 'tabstop').
-- Default limit for every filetype (setup); an after/ftplugin overrides it
-- with vim.b.overlength = <limit>, or disables it with vim.b.overlength = false.
local M = {}

local default = 80
local group = vim.api.nvim_create_augroup("overlength-bar", { clear = true })

local function update(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	local limit = vim.b[buf].overlength
	if limit == nil then
		limit = default
	end
	local bar = ""
	if limit then
		local hit = vim.api.nvim_buf_call(buf, function()
			return vim.fn.search([[\%>]] .. limit .. [[v.]], "nw")
		end)
		bar = hit > 0 and tostring(limit + 1) or ""
	end
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.wo[win][0].colorcolumn = bar
	end
end

function M.setup(limit)
	default = limit or default
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		desc = "Line-length bar",
		callback = function(ev)
			local buf = ev.buf
			if vim.bo[buf].buftype ~= "" then -- help, terminal, pickers, dashboard...
				return
			end
			vim.api.nvim_clear_autocmds({ group = group, buffer = buf })
			vim.api.nvim_create_autocmd({ "BufWinEnter", "TextChanged", "TextChangedI" }, {
				group = group,
				buffer = buf,
				callback = function()
					update(buf)
				end,
			})
			-- scheduled: runs after the ftplugins, which may set vim.b.overlength
			vim.schedule(function()
				update(buf)
			end)
		end,
	})
end

return M
