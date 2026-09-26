-- mini.files: edit the buffer to create/rename/delete, then `=` to apply
require("mini.files").setup({
	-- directories (nvim ., :e dir/) open in the snacks explorer, not here
	options = { use_as_default_explorer = false },
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		vim.keymap.set("n", "<Esc>", function()
			require("mini.files").close()
		end, { buffer = args.data.buf_id, desc = "Close mini.files" })
	end,
})

-- Two explorers: ee = mini.files at the current file, et = snacks sidebar
vim.keymap.set("n", "<leader>ee", function()
	local path = vim.api.nvim_buf_get_name(0)
	-- reveal the file if it exists on disk, otherwise its folder, otherwise cwd
	if path == "" or not vim.uv.fs_stat(path) then
		path = vim.fn.fnamemodify(path, ":h")
		if path == "" or not vim.uv.fs_stat(path) then
			path = vim.uv.cwd()
		end
	end
	require("mini.files").open(path)
end, { desc = "Explorer (mini.files)" })
vim.keymap.set("n", "<leader>et", function()
	Snacks.explorer()
end, { desc = "Explorer (Sidebar)" })
