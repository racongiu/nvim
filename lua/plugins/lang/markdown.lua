-- Markdown: marksman only, no formatter (READMEs have no prettier config).
-- render-markdown.nvim: in-buffer rendering (headings, code blocks, tables,
-- checkboxes) via the bundled markdown/markdown_inline treesitter parsers;
-- glyphs come from mini.icons, read directly by render-markdown.
return {
	lsp = { "marksman" },
	tools = { "marksman" },
	plugins = {
		{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	},
	setup = function()
		require("render-markdown").setup({
			latex = { enabled = false }, -- no latex toolchain installed (see snacks.image)
		})
	end,
}
