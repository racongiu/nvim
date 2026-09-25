-- Startup time, read by the snacks dashboard
_G.START_TIME = vim.uv.hrtime()

-- Byte-compiled Lua module cache (opt-in, :h vim.loader)
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Each step is isolated: an error is reported (after startup) and the next
-- steps still load
for _, mod in ipairs({ "config.opts", "config.keymaps", "config.commands", "config.autocmds", "config.pack" }) do
	local ok, err = pcall(function()
		require(mod).init()
	end)
	if not ok then
		vim.schedule(function()
			vim.notify(("config: %s failed\n%s"):format(mod, err), vim.log.levels.ERROR)
		end)
	end
end
