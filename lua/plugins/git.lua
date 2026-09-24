local icons = require("utils.icons")
local signs = {
	add = { text = icons.git.add },
	change = { text = icons.git.change },
	changedelete = { text = icons.git.changedelete },
	untracked = { text = icons.git.untracked },
}

require("gitsigns").setup({
	signs = signs,
	signs_staged = signs,
	numhl = true,
	on_attach = function(bufnr)
		local gs = require("gitsigns")
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("<leader>gp", gs.preview_hunk, "Preview Hunk")
		map("<leader>gb", gs.toggle_current_line_blame, "Toggle Line Blame")
	end,
})

-- lazygit: the module is configured in snacks.lua, the entry point lives here
vim.keymap.set("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })
