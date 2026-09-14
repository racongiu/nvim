local pack = {}

-- Load every .lua file in a folder, alphabetical order, non-recursive
-- (subfolders are imported separately).
local function import(mod)
	local dir = vim.fn.stdpath("config") .. "/lua/" .. mod:gsub("%.", "/")
	for _, file in ipairs(vim.fn.globpath(dir, "*.lua", false, true)) do
		require(mod .. "." .. vim.fn.fnamemodify(file, ":t:r"))
	end
end

function pack.init()
	vim.pack.add({
		{ src = "https://github.com/f-person/auto-dark-mode.nvim" },
		{ src = "https://github.com/catppuccin/nvim", name = "catppuccin-nvim" },
		{ src = "https://github.com/nvim-mini/mini.nvim", version = "stable" },
		{ src = "https://github.com/folke/which-key.nvim" },
		{ src = "https://github.com/b0o/incline.nvim" },
		{ src = "https://github.com/folke/snacks.nvim" },
		{ src = "https://github.com/nvim-lualine/lualine.nvim" },
		{ src = "https://github.com/lewis6991/gitsigns.nvim" },
		{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
		{ src = "https://github.com/SmiteshP/nvim-navic" },
		{ src = "https://github.com/christoomey/vim-tmux-navigator" }, -- no config file
		{ src = "https://github.com/Diogo-ss/42-header.nvim" },
		-- v1 stable (latest 1.x tag); on a release tag blink downloads its
		-- prebuilt fuzzy binary itself (no build step, no blink.lib)
		{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
		{ src = "https://github.com/rafamadriz/friendly-snippets" },
		{ src = "https://github.com/mason-org/mason.nvim" },
		{ src = "https://github.com/stevearc/conform.nvim" },
		{ src = "https://github.com/mfussenegger/nvim-lint" },
		{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
		{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
		{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
		{ src = "https://github.com/luukvbaal/statuscol.nvim" }, -- icon-only fold column
	})

	import("plugins")
	import("plugins.colorschemes")
	import("plugins.lsp")
end

return pack
