local keymaps = {}

function keymaps.init()
	local keymap = vim.keymap

	keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart Neovim (:restart)" })

	keymap.set("n", "<up>", "<nop>", { silent = true })
	keymap.set("n", "<down>", "<nop>", { silent = true })
	keymap.set("n", "<left>", "<nop>", { silent = true })
	keymap.set("n", "<right>", "<nop>", { silent = true })
	keymap.set("n", "q", "<nop>", { silent = true }) -- no macros

	keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
	keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })
	keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

	keymap.set("x", "<", "<gv", { desc = "Unindent and keep selection" })
	keymap.set("x", ">", ">gv", { desc = "Indent and keep selection" })

	keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch", silent = true })

	-- Windows (<leader>w group, declared in which-key)
	keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Close Window" })
	keymap.set("n", "<leader>ws", "<C-W>s", { desc = "Split Below" })
	keymap.set("n", "<leader>wv", "<C-W>v", { desc = "Split Right" })

	keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save file", silent = true })
end

return keymaps
