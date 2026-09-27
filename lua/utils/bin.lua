-- Tool binary lookup, used by the formatting and linting engines: the project's
-- own install first (node_modules/.bin, .venv/bin, venv/bin, searched upward
-- from the buffer), else the bare name, which $PATH resolves: system binaries
-- first, then mason's (appended to $PATH, see plugins/lsp/lsp.lua).
local M = {}

local project_dirs = { "node_modules/.bin", ".venv/bin", "venv/bin" }

function M.resolve(bufnr, name)
	local file = vim.api.nvim_buf_get_name(bufnr)
	if file ~= "" then
		for dir in vim.fs.parents(file) do
			for _, sub in ipairs(project_dirs) do
				local bin = vim.fs.joinpath(dir, sub, name)
				if vim.fn.executable(bin) == 1 then
					return bin
				end
			end
		end
	end
	return name
end

return M
