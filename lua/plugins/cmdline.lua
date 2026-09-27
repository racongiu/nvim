-- Floating cmdline (tiny-cmdline.nvim) on top of ui2, Neovim 0.12's EXPERIMENTAL
-- message/cmdline UI. Self-contained: cmdheight is set to 0 only once ui2 is
-- on, so if anything here fails the classic cmdline stays. To go back: delete
-- this file and the tiny-cmdline line in config/pack.lua.
require("vim._core.ui2").enable({
	msg = { target = "msg" }, -- messages in a small ephemeral window (no cmdline row)
})
vim.o.cmdheight = 0
vim.o.showcmdloc = "statusline" -- pending keys (e.g. "2d"), shown by lualine's %S

require("tiny-cmdline").setup({
	-- keep blink's cmdline completion menu attached to the floating cmdline
	on_reposition = require("tiny-cmdline").adapters.blink,
})
