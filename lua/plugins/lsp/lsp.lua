-- tiny-inline-diagnostic replaces the native virtual_text (kept disabled below)
require("tiny-inline-diagnostic").setup({
	options = { use_icons_from_diagnostic = true }, -- reuse the signcolumn icons
})

local icons = require("utils.icons")
vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = true, -- refresh diagnostics while typing (LSP + nvim-lint)
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
			[vim.diagnostic.severity.WARN] = icons.diagnostics.warn,
			[vim.diagnostic.severity.INFO] = icons.diagnostics.info,
			[vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
		},
	},
})

-- LSP engine: aggregates plugins/lang/*.lua, installs binaries via mason and
-- enables the servers. Server configs are standalone files in nvim/lsp/*.lua
-- (no nvim-lspconfig).
local servers, tools, seen = {}, {}, {}
for _, lang in ipairs(require("utils.langs").list()) do
	for _, server in ipairs(lang.lsp or {}) do
		if not seen[server] then -- a server may be shared by several langs
			seen[server] = true
			servers[#servers + 1] = server
		end
	end
	vim.list_extend(tools, lang.tools or {})
	if lang.setup then
		lang.setup()
	end
end

require("mason").setup({
	PATH = "append", -- project/system binaries first, mason as fallback
	ui = {
		border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
require("mason-tool-installer").setup({ ensure_installed = tools })

vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })

vim.lsp.enable(servers)
