local icons = require("utils.icons")

require("snacks").setup({
	bigfile = { enabled = true },
	indent = { enabled = true },
	scope = { enabled = true },
	explorer = { enabled = true },
	image = { enabled = true },
	input = { enabled = true }, -- floating window for vim.ui.input (LSP rename, new file...)
	notifier = {
		enabled = true,
		level = vim.log.levels.INFO,
	},
	lazygit = {
		enabled = true,
		config = { quitOnTopLevelReturn = true },
	},
	dashboard = {
		enabled = true,
		preset = {
			keys = {
				{ key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ key = "n", desc = "New File", action = ":ene | startinsert" },
				{ key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
				{ key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				{ key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
				{
					key = "c",
					desc = "Config",
					action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
				},
				{ key = "q", desc = "Quit", action = ":qa" },
			},
			header = require("utils.logos").random(),
		},
		sections = {
			{ section = "header", pane = 2 },
			{ section = "keys", indent = 1, padding = 1 },
			{ section = "projects", title = "Projects", indent = 3, padding = 2 },
			{ section = "recent_files", title = "Recent Files", indent = 3, padding = 2 },
			-- startup time, measured from _G.START_TIME (init.lua)
			function()
				local ms = math.floor((vim.uv.hrtime() - (_G.START_TIME or vim.uv.hrtime())) / 1e6 + 0.5)
				return {
					align = "center",
					padding = 1,
					text = { { "⚡ Neovim loaded in " .. ms .. " ms", hl = "footer" } },
				}
			end,
		},
	},
	picker = {
		enabled = true, -- also replaces vim.ui.select
		sources = {
			files = { hidden = true },
			explorer = { hidden = true, ignored = true }, -- dotfiles + gitignored files
		},
		icons = {
			kinds = icons.kinds,
			diagnostics = {
				Error = icons.diagnostics.error,
				Warn = icons.diagnostics.warn,
				Info = icons.diagnostics.info,
				Hint = icons.diagnostics.hint,
			},
		},
	},
})

local keymap = vim.keymap

-- Find
keymap.set("n", "<leader>ff", function()
	Snacks.picker.files()
end, { desc = "Find Files" })
keymap.set("n", "<leader>fg", function()
	Snacks.picker.grep()
end, { desc = "Live Grep" })
keymap.set("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
keymap.set("n", "<leader>fs", function()
	Snacks.picker.lsp_symbols()
end, { desc = "Document Symbols" })
keymap.set("n", "<leader>fr", function()
	Snacks.picker.recent()
end, { desc = "Recent Files" })
keymap.set("n", "<leader>fhh", function()
	Snacks.picker.help()
end, { desc = "Help Tags" })
keymap.set("n", "<leader>fhc", function()
	Snacks.picker.commands()
end, { desc = "Commands" })
keymap.set("n", "<leader>fhk", function()
	Snacks.picker.keymaps()
end, { desc = "Keymaps" })

-- Notifications
keymap.set("n", "<leader>snh", function()
	Snacks.picker.notifications()
end, { desc = "Notification History" })
keymap.set("n", "<leader>snd", function()
	Snacks.notifier.hide()
end, { desc = "Dismiss Notifications" })
