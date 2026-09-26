-- Install missing tree-sitter parsers (async, no-op when present).
-- c and lua ship with neovim but are reinstalled on purpose: parser and
-- queries then both come from nvim-treesitter (one consistent source).
-- No tree-sitter CLI (42 machines) = no install: neovim's bundled parsers
-- (c, lua...) still work, the rest falls back to regex syntax
if vim.fn.executable("tree-sitter") == 1 then
	require("nvim-treesitter").install({
		"c",
		"cpp",
		"lua",
		"python",
	})
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),
	desc = "Tree-sitter highlight when a parser exists",
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- Native treesitter folds; foldlevelstart 99 = everything open on load.
-- Filetypes without a parser simply get no folds
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 99
-- fold indicators in the gutter (glyphs from utils/icons)
local fold_icons = require("utils.icons").fold
vim.o.foldcolumn = "1"
vim.opt.fillchars:append({
	foldopen = fold_icons.open,
	foldclose = fold_icons.closed,
	foldsep = " ",
})
-- statuscol: redraw the fold column with the glyphs only -- the native
-- rendering falls back to fold-level DIGITS once nesting exceeds the
-- foldcolumn width (:h 'foldcolumn')
local builtin = require("statuscol.builtin")
require("statuscol").setup({
	segments = {
		{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
		{ text = { "%s" }, click = "v:lua.ScSa" },
		{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
	},
})

require("mini.pairs").setup()
require("mini.cursorword").setup()

local cmp = require("blink.cmp")
local icons = require("utils.icons")

-- blink.cmp v1 on a release tag downloads its prebuilt fuzzy binary
-- itself: no build step needed

cmp.setup({
	-- 'default' preset: <C-y> accept, <C-space> menu/docs, <C-e> hide, <C-n>/<C-p> select
	keymap = {
		preset = "default",
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		-- <C-k> override eats the preset's signature toggle; rehome it
		["<C-l>"] = { "show_signature", "hide_signature", "fallback" },
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			window = { border = "rounded" },
		},
		menu = {
			border = "rounded",
			min_width = 24,
			max_height = 12,
			draw = {
				treesitter = { "lsp" },
				components = {
					-- centralized kind icons (utils/icons); blink's as fallback
					kind_icon = {
						text = function(ctx)
							return icons.kinds[ctx.kind] or (ctx.kind_icon .. ctx.icon_gap)
						end,
					},
				},
			},
		},
	},
	signature = { enabled = true },
})
