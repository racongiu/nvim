local autocmds = {}

function autocmds.init()
	-- Line-length bar: 80 by default (42 norm, Prettier, clang-format, yamllint...);
	-- after/ftplugin overrides it with vim.b.overlength (python 79, lua 120, markdown off)
	require("utils.overlength").setup(80)

	vim.api.nvim_create_autocmd("TextYankPost", {
		group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
		desc = "Highlight when yanking (copying) text",
		callback = function()
			vim.hl.on_yank()
		end,
	})

	-- Plugin build hooks. NOTE: must run before the first vim.pack.add() (config.pack)
	vim.api.nvim_create_autocmd("PackChanged", {
		group = vim.api.nvim_create_augroup("pack-build", { clear = true }),
		callback = function(ev)
			local name, kind = ev.data.spec.name, ev.data.kind
			-- "install" is covered by install() in coding.lua at startup.
			-- Rebuilding parsers needs the tree-sitter CLI (absent on 42 machines)
			if name == "nvim-treesitter" and kind == "update" and vim.fn.executable("tree-sitter") == 1 then
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				vim.cmd("TSUpdate")
			end
		end,
	})
end

return autocmds
