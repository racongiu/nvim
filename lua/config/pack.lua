local pack = {}

-- Run fn; on error, report it once startup is done and keep going, so one
-- broken file never takes the rest of the config down with it
local function safe(what, fn)
	local ok, err = pcall(fn)
	if not ok then
		vim.schedule(function()
			vim.notify(("config: %s failed\n%s"):format(what, err), vim.log.levels.ERROR)
		end)
	end
end

-- Load every .lua file in a folder, alphabetical order, non-recursive
-- (subfolders are imported separately). Each file is isolated.
local function import(mod)
	local dir = vim.fn.stdpath("config") .. "/lua/" .. mod:gsub("%.", "/")
	for _, file in ipairs(vim.fn.globpath(dir, "*.lua", false, true)) do
		local name = mod .. "." .. vim.fn.fnamemodify(file, ":t:r")
		safe(name, function()
			require(name)
		end)
	end
end

function pack.init()
	safe("vim.pack.add", function()
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
			-- pinned to the last v1 tag: a "1.*" range would also accept a 2.0
			-- pre-release (v2 needs blink.lib + a build step). On a release tag
			-- blink downloads its prebuilt fuzzy binary itself.
			{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
			{ src = "https://github.com/rafamadriz/friendly-snippets" },
			{ src = "https://github.com/mason-org/mason.nvim" },
			{ src = "https://github.com/stevearc/conform.nvim" },
			{ src = "https://github.com/mfussenegger/nvim-lint" },
			{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
			{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
			{ src = "https://github.com/luukvbaal/statuscol.nvim" }, -- icon-only fold column
		})
	end)

	-- File/filetype icons for every plugin (snacks, which-key, render-markdown,
	-- incline, lualine all call MiniIcons directly: no nvim-web-devicons mock)
	safe("mini.icons", function()
		require("mini.icons").setup()
	end)

	import("plugins")
	import("plugins.colorschemes")
	import("plugins.lsp")
end

return pack
