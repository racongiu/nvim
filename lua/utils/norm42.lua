-- 42 norm tool definitions (norminette + c_formatter_42), consumed by
-- plugins/lang/c.lua for C projects without a .clang-format.
-- Binaries come from PATH, not mason: pipx install norminette c-formatter-42
local M = {}

-- conform definition: c_formatter_42 reads stdin, writes stdout
M.c_formatter_42 = { command = "c_formatter_42", args = {}, stdin = true }

-- norminette reports a VISUAL column (a tab advances to the next multiple of
-- 4, 1-based); Neovim wants a 0-based byte index into the buffer line.
local function byte_col(bufnr, lnum, vcol)
	local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1] or ""
	local vc = 1
	for i = 1, #line do
		if vc >= vcol then
			return i - 1
		end
		vc = line:sub(i, i) == "\t" and vc + 4 - (vc - 1) % 4 or vc + 1
	end
	return #line
end

-- norminette output: `Error: NAME (line: N, col: N):\tmessage` (1-based).
-- Errors without a position (e.g. PARSING_ERROR) are put on line 1 instead of
-- being dropped. The `file.c: Error!` header never matches (its name has a dot).
-- "Error" fails the norm (WARN); "Notice" is informational only, like
-- GLOBAL_VAR_DETECTED (INFO) -- the file status stays OK with notices.
local function parse_norminette(output, bufnr)
	local diagnostics = {}
	for _, line in ipairs(vim.split(output, "\n")) do
		local level, error_name, lnum, col, message =
			line:match("^(%a+):%s*([%w_]+)%s*%(line:%s*(%d+),%s*col:%s*(%d+)%):%s*(.*)$")
		if not level then
			level, error_name, message = line:match("^(%a+):%s*([%w_]+)%s+(.*)$")
		end
		if level == "Error" or level == "Notice" then
			local l = lnum and tonumber(lnum) - 1 or 0
			table.insert(diagnostics, {
				lnum = l,
				col = col and byte_col(bufnr, l, tonumber(col)) or 0,
				message = vim.trim(message),
				code = error_name,
				severity = (level == "Notice") and vim.diagnostic.severity.INFO
					or vim.diagnostic.severity.WARN,
				source = "norminette",
			})
		end
	end
	return diagnostics
end

-- nvim-lint definition (factory, re-evaluated on each lint run).
-- norminette has no stdin mode, but takes the buffer content as an
-- argument (--cfile/--hfile) plus a virtual --filename. No tmpfile:
-- the filename-based checks (.h include-guard name) stay correct.
function M.norminette()
	local bufnr = vim.api.nvim_get_current_buf()
	local name = vim.api.nvim_buf_get_name(bufnr)
	local ext = name:match("%.([ch])$") or "c"
	local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") .. "\n"
	local filename = name ~= "" and vim.fn.fnamemodify(name, ":t") or ("untitled." .. ext)
	return {
		cmd = "norminette",
		stdin = false,
		append_fname = false, -- never lint the on-disk file: content comes from the buffer
		args = {
			"--no-colors",
			(ext == "h") and "--hfile" or "--cfile",
			content,
			"--filename",
			filename,
		},
		stream = "stdout",
		ignore_exitcode = true, -- exits 1 whenever errors are found
		parser = parse_norminette,
	}
end

return M
