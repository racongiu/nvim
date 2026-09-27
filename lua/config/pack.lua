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
			-- Core: used across the whole config
			{ src = "https://github.com/folke/snacks.nvim" },
			{ src = "https://github.com/nvim-mini/mini.nvim", version = "stable" },

			-- Colorscheme (plugins/colorschemes/)
			{ src = "https://github.com/catppuccin/nvim", name = "catppuccin-nvim" },
			{ src = "https://github.com/f-person/auto-dark-mode.nvim" },

			-- UI (ui.lua)
			{ src = "https://github.com/folke/which-key.nvim" },
			{ src = "https://github.com/nvim-lualine/lualine.nvim" },
			{ src = "https://github.com/b0o/incline.nvim" },
			{ src = "https://github.com/SmiteshP/nvim-navic" },
			{ src = "https://github.com/rachartier/tiny-cmdline.nvim" }, -- cmdline.lua

			-- Editing (coding.lua)
			{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
			-- pinned to the last v1 tag: a "1.*" range would also accept a 2.0
			-- pre-release (v2 needs blink.lib + a build step). On a release tag
			-- blink downloads its prebuilt fuzzy binary itself.
			{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
			{ src = "https://github.com/rafamadriz/friendly-snippets" },
			{ src = "https://github.com/windwp/nvim-ts-autotag" },

			-- LSP and tools (plugins/lsp/, lsp/)
			{ src = "https://github.com/mason-org/mason.nvim" },
			{ src = "https://github.com/b0o/SchemaStore.nvim" }, -- data only (no setup): read by lsp/jsonls.lua and lsp/yamlls.lua
			{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },

			-- Formatting and linting (format.lua, lint.lua)
			{ src = "https://github.com/stevearc/conform.nvim" },
			{ src = "https://github.com/mfussenegger/nvim-lint" },

			-- Git (git.lua)
			{ src = "https://github.com/lewis6991/gitsigns.nvim" },

			-- Navigation and 42
			{ src = "https://github.com/christoomey/vim-tmux-navigator" }, -- no config file
			{ src = "https://github.com/Diogo-ss/42-header.nvim" },
		})
	end)

	-- Plugins used by a single language (plugins/lang/*.lua `plugins` field).
	-- Added after the main list: lang files require main-list plugins (conform.util in lang/c.lua)
	safe("lang plugins", function()
		local specs = require("utils.langs").plugins()
		if #specs > 0 then
			vim.pack.add(specs)
		end
	end)

	-- File/filetype icons for every plugin (snacks, which-key, render-markdown,
	-- incline, lualine all call MiniIcons directly: no nvim-web-devicons mock)
	safe("mini.icons", function()
		require("mini.icons").setup()
	end)

	import("plugins")
	import("plugins.colorschemes")
	import("plugins.lsp")

	-- Language-specific plugin config (plugins/lang/*.lua `setup` field)
	safe("lang setup", function()
		require("utils.langs").setup()
	end)
end

return pack
