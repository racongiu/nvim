-- C / C++: clangd + tools chosen per project.
-- Project with a .clang-format -> clang-format. Otherwise a C file follows the
-- 42 norm (c_formatter_42 + norminette) and a C++ file is not formatted.
-- clang-tidy runs inside clangd (project's .clang-tidy, else clangd's default checks).
local norm = require("utils.norm42")
local markers = { ".clang-format", "_clang-format" }

return {
	lsp = { "clangd" },
	tools = { "clangd", "clang-format" },
	formatters = {
		c = { "clang-format", "c_formatter_42", stop_after_first = true },
		cpp = { "clang-format" },
	},
	custom_formatters = {
		["clang-format"] = { cwd = require("conform.util").root_file(markers), require_cwd = true },
		c_formatter_42 = norm.c_formatter_42,
	},
	linters = {
		c = function(bufnr)
			local is42 = vim.fs.root(bufnr, markers) == nil
			return is42 and vim.fn.executable("norminette") == 1 and { "norminette" } or {}
		end,
	},
	custom_linters = { norminette = norm.norminette },
}
