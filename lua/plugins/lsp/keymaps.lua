local keymap = vim.keymap

-- [d / ]d (any diagnostic) are builtin defaults (:h ]d-default); errors get their own pair
keymap.set("n", "[e", function()
	vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous Error", silent = true })
keymap.set("n", "]e", function()
	vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next Error", silent = true })
keymap.set("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Show Diagnostic", silent = true })
keymap.set("n", "<leader>xD", function()
	Snacks.picker.diagnostics()
end, { desc = "All Diagnostics", silent = true })
keymap.set("n", "<leader>xq", vim.diagnostic.setqflist, { desc = "Quickfix Diagnostics", silent = true })

-- LSP (buffer-local, on attach). Builtin defaults already cover: K hover,
-- grn rename, gra code action, grr references, gri implementation,
-- grt type definition, gO symbols, <C-s> signature help (insert).
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-keymaps", { clear = true }),
	callback = function(ev)
		local map = function(mode, lhs, rhs, desc)
			keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc, silent = true })
		end

		-- Navigation
		map("n", "<leader>cd", vim.lsp.buf.definition, "Goto Definition")
		map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("n", "<leader>cr", vim.lsp.buf.references, "References")
		map("n", "<leader>ct", vim.lsp.buf.type_definition, "Type Definition")

		-- Actions
		map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map("n", "<leader>cR", vim.lsp.buf.rename, "Rename Symbol")

		-- Symbols (document symbols live on <leader>fs, in the Find group)
		map("n", "<leader>cws", function()
			Snacks.picker.lsp_workspace_symbols()
		end, "Workspace Symbols")

		-- Workspace
		map("n", "<leader>cwl", function()
			vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "List Workspace Folders")

		map("n", "<leader>ci", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			map("n", "<leader>ch", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
			end, "Toggle Inlay Hints")
		end

		-- navic breadcrumb winbar, per window: only where symbols exist
		-- (a global 'winbar' would show an empty bar in LSP-less windows)
		if client and client:supports_method("textDocument/documentSymbol") then
			vim.wo[0][0].winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
		end
	end,
})
