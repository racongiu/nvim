-- Centralized icons for the whole config
local M = {}

M.diagnostics = {
	error = "❌",
	warn = "⚠️",
	info = "💡",
	hint = "ℹ️",
}

-- gitsigns gutter glyphs (delete/topdelete: gitsigns defaults)
M.git = {
	add = "▎",
	change = "▎",
	changedelete = "▎",
	untracked = "▎",
}

-- fold gutter glyphs ('fillchars', see the folds section of plugins/coding.lua)
M.fold = {
	open = "\u{EAB4}", -- nf-cod-chevron_down
	closed = "\u{EAB6}", -- nf-cod-chevron_right
}

-- lualine custom components
M.statusline = {
	formatters = "󰉼",
	linters = "󰁨",
	branch = "󰊢",
	diff = { added = "󰐕 ", modified = "󰏫 ", removed = "󰍵 " },
}

-- LSP symbol kinds (navic, blink, snacks)
M.kinds = {
	File = "󰈙 ",
	Module = "󰏗 ",
	Namespace = "󰌗 ",
	Package = "󰏖 ",
	Class = "󰌗 ",
	Method = "󰆧 ",
	Property = "󰜢 ",
	Field = "󰜢 ",
	Enum = "󰕘 ",
	Interface = "󰕘 ",
	Function = "󰊕 ",
	Variable = "󰆧 ",
	Constant = "󰏿 ",
	String = "󰀬 ",
	Number = "󰎠 ",
	Boolean = "◩ ",
	Array = "󰅪 ",
	Object = "󰅩 ",
	Key = "󰌋 ",
	Null = "󰟢 ",
	Struct = "󰌗 ",
	Operator = "󰆕 ",
	TypeParameter = "󰊄 ",
}

return M
