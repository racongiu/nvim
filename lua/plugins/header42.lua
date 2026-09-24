-- 42-header.nvim: :Stdheader inserts the school header (any filetype,
-- follows 'commentstring'), refreshed on save.
require("42header").setup({
	default_map = false, -- :Stdheader only, no <F1>
	auto_update = true,
	-- NOTE: at this plugin revision vim.g.user / $USER and vim.g.mail / $MAIL
	-- take precedence over these two opts
	user = "racongiu", -- 42 login
	mail = "racongiu@student.42.fr",
})
