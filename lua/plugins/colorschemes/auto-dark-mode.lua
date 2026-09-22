-- auto-dark-mode reads the theme of the desktop nvim runs on: `defaults` on
-- macOS, the xdg-desktop-portal through `dbus-send` on Linux. Skipped over
-- SSH (the remote desktop is not the one in front of you) and on Linux
-- without dbus-send (VPS). setup() is pcall'd: it error()s on several setups
-- (no dbus-send, root without $SUDO_USER, WSL interop off...), and an error
-- here would abort the rest of config.pack (catppuccin.lua, plugins/lsp).
-- Fallback: 'background' pinned to dark (the plugin's own default), which
-- catppuccin's flavour "auto" follows.
local usable = not vim.env.SSH_CONNECTION
	and not (vim.fn.has("linux") == 1 and vim.fn.executable("dbus-send") == 0)

if usable then
	-- default hooks already toggle 'background'
	local ok, err = pcall(require("auto-dark-mode").setup, { update_interval = 1000 })
	if ok then
		return
	end
	vim.notify(tostring(err), vim.log.levels.WARN)
end

vim.o.background = "dark"
