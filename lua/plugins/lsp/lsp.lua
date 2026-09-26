-- tiny-inline-diagnostic replaces the native virtual_text (kept disabled below)
require("tiny-inline-diagnostic").setup({
	options = { use_icons_from_diagnostic = true }, -- reuse the signcolumn icons
})

local icons = require("utils.icons")
vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = true, -- refresh diagnostics while typing (LSP + nvim-lint)
	virtual_text = false, -- required by tiny-inline-diagnostic (don't rely on the default)
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
local servers, tools = {}, {}
for _, lang in ipairs(require("utils.langs").list()) do
	vim.list_extend(servers, lang.lsp or {})
	vim.list_extend(tools, lang.tools or {})
end
-- a server or a mason tool may be shared by several langs (e.g. yamlls)
vim.list.unique(servers)
vim.list.unique(tools)

require("mason").setup({
	PATH = "append", -- project/system binaries first, mason as fallback
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
-- Install the lang files' tools that are missing (no-op once installed).
-- The callback may run off the main loop: schedule it. An unknown name means a
-- typo in a lang file, or no registry yet (first start offline): one warning.
local registry = require("mason-registry")
registry.refresh(vim.schedule_wrap(function()
	local unknown = {}
	for _, name in ipairs(tools) do
		local ok, pkg = pcall(registry.get_package, name)
		if not ok then
			unknown[#unknown + 1] = name
		elseif not pkg:is_installed() and not pkg:is_installing() then
			pkg:install()
		end
	end
	if #unknown > 0 then
		vim.notify("mason: not in registry (offline or typo): " .. table.concat(unknown, ", "), vim.log.levels.WARN)
	end
end))

vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" })

vim.lsp.enable(servers)
