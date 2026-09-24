local opts = {}

function opts.init()
	local opt = vim.opt

	-- .h = C (Neovim defaults to cpp: headers would get clang-format and no norminette)
	vim.g.c_syntax_for_h = true

	-- Unused providers (:h provider)
	vim.g.loaded_node_provider = 0
	vim.g.loaded_perl_provider = 0
	vim.g.loaded_python3_provider = 0
	vim.g.loaded_ruby_provider = 0

	vim.g.netrw_banner = 0

	-- Interface
	opt.number = true
	opt.relativenumber = true
	opt.cursorline = true
	opt.wrap = false
	opt.signcolumn = "yes"
	opt.list = true
	opt.listchars:append("eol:↴")
	opt.guicursor = ""
	opt.scrolloff = 8
	opt.colorcolumn = "80"
	opt.laststatus = 3
	opt.cmdheight = 0

	-- Indentation
	opt.tabstop = 4
	opt.softtabstop = 4
	opt.shiftwidth = 4

	-- Search
	opt.ignorecase = true
	opt.smartcase = true
	opt.inccommand = "split"

	-- Native completion only (blink.cmp ignores 'completeopt')
	opt.completeopt = "menuone,noselect,fuzzy,nosort"

	-- Files
	opt.autowrite = true
	opt.confirm = true
	opt.swapfile = false
	opt.isfname:append("@-@")

	-- Splits
	opt.splitbelow = true
	opt.splitright = true

	-- Mouse
	opt.mouse = "a"
	opt.mousescroll = "ver:3,hor:0"
	opt.timeoutlen = 300

	-- Clipboard
	opt.clipboard = "unnamedplus"

	opt.undofile = true
end

return opts
