-- 42-header.nvim: :Stdheader inserts the school header (any filetype,
-- follows 'commentstring'), refreshed on save.
vim.g.user = "racongiu" -- 42 login
vim.g.mail = "racongiu@student.42.fr"

require("42header").setup({
	default_map = false, -- :Stdheader only, no <F1>
	auto_update = true,
})
